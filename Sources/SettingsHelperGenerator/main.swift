import Foundation

if #available(macOS 11, *) {
    let buildDirFromArgs = CommandLine.arguments.first!
    let buildOutputDir = CommandLine.arguments[1]

    let projectDir = buildDirFromArgs + "../../SourcePackages/checkouts/"

    let projects = try! FileManager.default.contentsOfDirectory(atPath: projectDir)

    struct License {
        let projectName: String
        let licenseFilePath: String
    }

    let licenseFilesPath = projects
        .compactMap({ (dir: String) -> License? in
            guard let licenseFilePath = (try? FileManager.default.contentsOfDirectory(atPath: dir))?
                .compactMap({ $0 })
                .filter({ $0.starts(with: "LICENSE" )} )
                .first else {
                return nil
            }
            let url = URL(fileURLWithPath: dir, isDirectory: true)
            return License(projectName: url.lastPathComponent, licenseFilePath: licenseFilePath)
    })

    var licenseUrlInCopyResources = URL(fileURLWithPath: buildOutputDir)
    licenseUrlInCopyResources.appendPathComponent("licensesFromAmazingSettingsFrameworks", isDirectory: true)

    try! FileManager.default.createDirectory(at: licenseUrlInCopyResources, withIntermediateDirectories: false, attributes: nil)

    licenseFilesPath.forEach({ license in
        let targetFilePath = licenseUrlInCopyResources.appendingPathComponent(license.projectName + ".txt")
        try! FileManager.default.copyItem(at: URL(fileURLWithPath: license.licenseFilePath), to: targetFilePath)
    })

    print("Done")
}

