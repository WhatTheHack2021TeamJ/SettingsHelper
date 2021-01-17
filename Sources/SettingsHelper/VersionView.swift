//
//  VersionView.swift
//  
//
//  Created by Yon Montoto on 1/17/21.
//

import SwiftUI

public class VersionFooterModel: ObservableObject {
    public let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    public let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
}

struct VersionFooterView: View {
    let version: VersionFooterModel
    
    var body: some View {
        Text("Version " + version.versionNumber + " " + "(\(version.buildNumber))").frame(maxWidth: .infinity)
    }
}
