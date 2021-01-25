//
//  CreditsView.swift
//  SettingsHelper
//
//  Created by Yannick Rave on 17.01.21.
//

import SwiftUI

public struct DataPrivacyRow<ViewModel: TextContentViewModel>: View {
    @ObservedObject var dataPrivacyViewModel: ViewModel
    var color: Color?

    var title: String = NSLocalizedString("Data Privacy", bundle: .module, comment: "")

    public var body: some View {
        SettingsRow(title: self.title, systemImage: "checkmark.shield", color: self.color, destination: { TextContentView(viewModel: self.dataPrivacyViewModel) })
    }
}

public struct CreditsRow<ViewModel: TextContentViewModel>: View {
    @ObservedObject var creditsViewModel: ViewModel
    var color: Color?

    var title: String = NSLocalizedString("Credits", bundle: .module, comment: "")

    public var body: some View {
        SettingsRow(title: self.title, systemImage: "heart", color: self.color, destination: { TextContentView(viewModel: self.creditsViewModel) })
    }
}

public struct TextContentView<ViewModel: TextContentViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    public var body: some View {
        ScrollView {
            Text(viewModel.getCredits() ?? "-")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
}

public protocol TextContentViewModel: ObservableObject {
    func getCredits() -> String?
}

public class FileTextContentViewModel: TextContentViewModel {
    public let file: SettingsContent

    public init(file: SettingsContent) {
        self.file = file
    }

    public func getCredits() -> String? {
        file.content
    }
}

class StaticTextContentViewModel: TextContentViewModel {
    func getCredits() -> String? {
        "This is some Fake Credits. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
    }
}

public protocol SettingsContent {
    var content: String? { get }
}

public struct SettingsFile: SettingsContent {
    public let resource: String
    public let fileExtension: String

    public var content: String? {
        guard let fileURL = Bundle.main.url(forResource: self.resource, withExtension: self.fileExtension) else { return nil }
        guard let content = try? String(contentsOf: fileURL) else { return nil }
        return content
    }
}

public struct StaticTextContent: SettingsContent {
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
        TextContentView(viewModel: StaticTextContentViewModel())
    }
}
