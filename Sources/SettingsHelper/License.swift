//
//  License.swift
//  
//
//  Created by Yannick Rave on 17.01.21.
//

import SwiftUI


struct LicensesRow: View {
    var licenses: [License]
    var title: LocalizedStringKey = "Licenses"
    var body: some View {
        NavigationLink(
            destination: LicensesPage(licenses: licenses)
                .navigationTitle(title),
            label: {
                Label(title, systemImage: "doc")
            })
    }
}

struct LicensesPage: View {
    var licenses: [License]
    var body: some View {
        List {
            ForEach(licenses) { license in
                LicenseDetails(license: license)
            }
        }.listStyle(InsetGroupedListStyle())
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
                .navigationTitle(license.title),
            label: {
                Label(license.title, systemImage: "doc")
            })
    }
}
