//
//  CreditsView.swift
//  SettingsHelper
//
//  Created by Yannick Rave on 17.01.21.
//

import SwiftUI

public struct CreditsRow<ViewModel: CreditsViewModel>: View {
    @ObservedObject var creditsViewModel: ViewModel

    var title: LocalizedStringKey = "Credits"

    public var body: some View {
        NavigationLink(
            destination: CreditsView(viewModel: self.creditsViewModel)
                .navigationTitle(title),
            label: {
                Label(title, systemImage: "person.3")
            })
    }
}

public struct CreditsView<ViewModel: CreditsViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    public var body: some View {
        ScrollView {
            Text(viewModel.getCredits() ?? "-")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
}

public protocol CreditsViewModel: ObservableObject {
    func getCredits() -> String?
}

public class Credits: CreditsViewModel {
    public let creditsFile: SettingsContent

    public init(creditsFile: SettingsContent) {
        self.creditsFile = creditsFile
    }

    public func getCredits() -> String? {
        creditsFile.content
    }
}

class FakeCredits: CreditsViewModel {
    func getCredits() -> String? {
        "This is some Fake Credits. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
    }
}

public protocol SettingsContent {
    var content: String? { get }
}

public struct CreditsFile: SettingsContent {
    public let resource: String
    public let fileExtension: String

    public var content: String? {
        guard let fileURL = Bundle.main.url(forResource: self.resource, withExtension: self.fileExtension) else { return nil }
        guard let content = try? String(contentsOf: fileURL) else { return nil }
        return content
    }
}

public struct CreditsContent: SettingsContent {
    private let _content: String
    public var content: String? {
        return self._content
    }

    public init(content: String) {
        self._content = content
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView(viewModel: FakeCredits())
    }
}
