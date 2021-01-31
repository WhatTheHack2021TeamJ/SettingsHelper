//
//  License.swift
//  
//
//  Created by Yannick Rave on 17.01.21.
//

import SwiftUI

struct LicensesRow: View {
    var licenses: [License]
    var color: Color?
    
    var title: String = NSLocalizedString("Licenses", bundle: .module, comment: "")

    var body: some View {
        SettingsRow(
            title: title,
            systemImage: "doc",
            color: self.color,
            destination: {
                LicensesPage(licenses: licenses)
            }
        )
    }
}

struct LicensesPage: View {
    var licenses: [License]
    var body: some View {
        List {
            ForEach(licenses) { license in
                LicenseDetails(license: license)
            }
        }.modifier(ListStyleModifier())
    }
}

struct License: Identifiable {
    var title: String
    var fullText: String

    var id: String { title }
}

struct LicenseDetails: View {
    @State private var isExpanded: Bool = false


    var license: License

    var body: some View {
        NavigationLink(
            destination: ScrollView { Text(license.fullText).padding() }
                .modifier(CompatibleNavigationTitle(title: license.title)),
            label: {
                CompatibleLabel(license.title, systemImage: "doc")
            })
    }
}
