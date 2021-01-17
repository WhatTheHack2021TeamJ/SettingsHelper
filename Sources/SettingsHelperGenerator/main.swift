import Foundation

if #available(macOS 11, *) {
    let buildDirFromArgs = CommandLine.arguments[1]
    let buildOutputDir = CommandLine.arguments[2]

    print(buildDirFromArgs)

    let projectDir = URL(fileURLWithPath: buildDirFromArgs)
        .deletingLastPathComponent() // Delete Products
        .deletingLastPathComponent() // Delete Build
        .appendingPathComponent("SourcePackages", isDirectory: true)
        .appendingPathComponent("checkouts", isDirectory: true)
        .path

    print(projectDir)

    let projects = try! FileManager.default.contentsOfDirectory(atPath: projectDir)

    struct License {
        let projectName: String
        let licenseFilePath: String
    }

    print(projects)

    let licenseFilesPath = projects
        .compactMap({
            let url = URL(fileURLWithPath: projectDir).appendingPathComponent($0).path
            var isDir: ObjCBool = false
            guard FileManager.default.fileExists(atPath: url, isDirectory: &isDir) else {
                return nil
            }
            guard isDir.boolValue else {
                return nil
            }
            return url
        })
        .compactMap({ (dir: String) -> License? in
            guard let licenseFileName = (try? FileManager.default.contentsOfDirectory(atPath: dir))?
                .compactMap({ $0 })
                .filter({ $0.starts(with: "LICENSE" )} )
                .first else {
                return nil
            }
            let url = URL(fileURLWithPath: dir, isDirectory: true)
            let licenseFilePath = URL(fileURLWithPath: dir).appendingPathComponent(licenseFileName).path
            return License(projectName: url.lastPathComponent, licenseFilePath: licenseFilePath)
    })

    var licenseUrlInCopyResources = URL(fileURLWithPath: buildOutputDir)
    licenseUrlInCopyResources.appendPathComponent("licensesFromAmazingSettingsFrameworks", isDirectory: true)

    if !FileManager.default.fileExists(atPath: licenseUrlInCopyResources.path) {
        try! FileManager.default.createDirectory(at: licenseUrlInCopyResources, withIntermediateDirectories: false, attributes: nil)
    }


    print(licenseFilesPath)

    licenseFilesPath.forEach({ license in
        let targetFilePath = licenseUrlInCopyResources.appendingPathComponent(license.projectName + ".txt")
        if FileManager.default.fileExists(atPath: targetFilePath.path) {
            //            FileManager.default.removeItem(atPath: targetFilePath.path)
            return
        }
        try! FileManager.default.copyItem(at: URL(fileURLWithPath: license.licenseFilePath), to: targetFilePath)
    })

    print("Done")
}

