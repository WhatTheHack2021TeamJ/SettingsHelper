#!/usr/bin/xcrun --sdk macosx swift
import Foundation

let env = ProcessInfo.processInfo.environment
guard let buildDir = env["BUILD_DIR"]
else { fatalError("Requires BUILD_DIR environment variable") }
let buildDirURL = URL(fileURLWithPath: buildDir)
guard let builtProductsDir = env["BUILT_PRODUCTS_DIR"]
else { fatalError("Requires BUILT_PRODUCTS_DIR environment variable") }
let builtProductsURL = URL(fileURLWithPath: builtProductsDir)
guard let resourcesComponent = env["WRAPPER_NAME"]
else { fatalError("Requires WRAPPER_NAME environment variable") }

let projectDir = buildDirURL.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("SourcePackages").appendingPathComponent("checkouts")
let buildOutputDir = builtProductsURL.appendingPathComponent(resourcesComponent).appendingPathComponent("licenses")


print("input", projectDir)
print("output", buildOutputDir)

let projects = try! FileManager.default.contentsOfDirectory(atPath: projectDir.path)

struct License {
    let projectName: String
    let licenseFilePath: String
}

print(projects)

let licenses = projects
    .compactMap({
        let url = projectDir.appendingPathComponent($0)
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) else {
            return nil
        }
        guard isDir.boolValue else {
            return nil
        }
        return url
    })
    .compactMap({ (dir: URL) -> License? in
        print("Dir: \(dir)")
        guard let licenseFileName = (try? FileManager.default.contentsOfDirectory(atPath: dir.path))?
            .first(where: { $0.starts(with: "LICENSE" ) }) else {
            return nil
        }
        let licenseFilePath = dir.appendingPathComponent(licenseFileName).path
        return License(projectName: dir.lastPathComponent, licenseFilePath: licenseFilePath)
})

print(licenses)

let licenseUrlInCopyResources = buildOutputDir

if !FileManager.default.fileExists(atPath: licenseUrlInCopyResources.path) {
    try! FileManager.default.createDirectory(at: licenseUrlInCopyResources, withIntermediateDirectories: false, attributes: nil)
}



licenses.forEach({ license in
    let targetFilePath = licenseUrlInCopyResources.appendingPathComponent(license.projectName + ".license")
    if FileManager.default.fileExists(atPath: targetFilePath.path) {
        //            FileManager.default.removeItem(atPath: targetFilePath.path)
        return
    }
    print("Copying \(license.projectName)")
    try! FileManager.default.copyItem(at: URL(fileURLWithPath: license.licenseFilePath), to: targetFilePath)
})

print("Done")
