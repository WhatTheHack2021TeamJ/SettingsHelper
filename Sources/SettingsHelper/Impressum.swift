//
//  Impressum.swift
//
//
//  Created by Yannick Rave on 25.01.21.
//

import SwiftUI

struct ImpressumRow: View {
    @ObservedObject var impressumViewModel: ImpressumViewModel
    var color: Color?

    var title: String = NSLocalizedString("Impressum", bundle: .module, comment: "")

    var body: some View {
        SettingsRow(
            title: self.title, systemImage: "person", color: self.color,
            destination: { ImpressumView(viewModel: self.impressumViewModel) })
    }
}

public struct SettingsImpressumContact {
    public var fullName: String
    public var streetAndHouseNumber: String
    public var postalCodeAndCity: String
    public var phoneNumber: String
    public var email: String

    public init(
        fullName: String, streetAndHouseNumber: String, postalCodeAndCity: String,
        phoneNumber: String, email: String
    ) {
        self.fullName = fullName
        self.streetAndHouseNumber = streetAndHouseNumber
        self.postalCodeAndCity = postalCodeAndCity
        self.phoneNumber = phoneNumber
        self.email = email
    }
}

public class ImpressumViewModel: ObservableObject {
    let contact: SettingsImpressumContact

    init(
        contact: SettingsImpressumContact
    ) {
        self.contact = contact
    }
}

public struct ImpressumView: View {
    @ObservedObject var viewModel: ImpressumViewModel

    public var body: some View {
        Form {
            Section(header: Text("Angaben gemäß § 5 TMG")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(self.viewModel.contact.fullName)
                    Text(self.viewModel.contact.streetAndHouseNumber)
                    Text(self.viewModel.contact.postalCodeAndCity)
                }
                .padding([.top, .bottom], 4)
            }
            Section(header: Text("Vertreten durch")) {
                Text(self.viewModel.contact.fullName)
            }
            Section(header: Text("Kontakt")) {
                Text(self.viewModel.contact.phoneNumber)
                Text(self.viewModel.contact.email)
            }
        }
    }
}

struct ImpressumView_Previews: PreviewProvider {
    static var previews: some View {
        ImpressumView(
            viewModel: ImpressumViewModel(
                contact: SettingsImpressumContact(
                    fullName: "First Last", streetAndHouseNumber: "Street 123",
                    postalCodeAndCity: "12345 City", phoneNumber: "+12 239293293",
                    email: "settings@test.com"))
        )
        .environment(\.colorScheme, .dark)
    }
}
