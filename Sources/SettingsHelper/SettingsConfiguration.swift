//
//  SettingsConfiguration.swift
//  SettingsHelper
//
//  Created by Yannick Rave on 17.01.21.
//

import Foundation
import SwiftUI

public enum LicenseOption {
    case useGeneratedLicenses, none
}

public enum CreditsOption {
    case useCredits(SettingsContent), none
}

public enum DataPrivacyOption {
    case useDataPrivacy(SettingsContent), none
}

public enum SettingsSytleOption {
    case normal, colorfulIcon(SettingsIconColors)

    var settingsIconColors: SettingsIconColors {
        switch self {
        case .normal:
            return SettingsIconColorsPlain()
        case .colorfulIcon(let settingsIconColors):
            return settingsIconColors
        }
    }
}

public enum ImpressumOption {
    case useImpressum(SettingsImpressumContact), none
}

public protocol SettingsIconColors {
    var feedbackColor: Color? { get }
    var faqColor: Color? { get }
    var licenseColor: Color? { get }
    var dataPrivacyColor: Color? { get }
    var creditsColor: Color? { get }
    var impressumColor: Color? { get }
}

public struct SettingsIconColorsColorful: SettingsIconColors {
    public let creditsColor: Color?
    public let dataPrivacyColor: Color?
    public let faqColor: Color?
    public let feedbackColor: Color?
    public let licenseColor: Color?
    public let impressumColor: Color?

    public init(creditsColor: Color, dataPrivacyColor: Color, faqColor: Color, feedbackColor: Color, licenseColor: Color, impressumColor: Color) {
        self.creditsColor = creditsColor
        self.dataPrivacyColor = dataPrivacyColor
        self.faqColor = faqColor
        self.feedbackColor = feedbackColor
        self.licenseColor = licenseColor
        self.impressumColor = impressumColor
    }

    public static let basic: SettingsIconColorsColorful = SettingsIconColorsColorful(creditsColor: .red, dataPrivacyColor: .green, faqColor: .gray, feedbackColor: .blue, licenseColor: .purple, impressumColor: .orange)
}

public struct SettingsIconColorsPlain: SettingsIconColors {
    public var creditsColor: Color? = nil
    public var dataPrivacyColor: Color? = nil
    public var faqColor: Color? = nil
    public var feedbackColor: Color? = nil
    public var licenseColor: Color? = nil
    public var impressumColor: Color? = nil
}

public class SettingsConfiguration {
    public var bundle: Bundle
    public var licenseUsage: LicenseOption
    public var email: String
    public var creditsUsage: CreditsOption
    public var dataPrivacyUsage: DataPrivacyOption
    public var questionsAndAnswers: [QuestionAndAnswer]
    public var settingsSytleOption: SettingsSytleOption
    public var impressumOption: ImpressumOption

    public init(email: String, licenseUsage: LicenseOption = .useGeneratedLicenses, bundle: Bundle = .main, creditsUsage: CreditsOption = .none, dataPrivacyUsage: DataPrivacyOption = .none, questionsAndAnswers: [QuestionAndAnswer] = [], impressumOption: ImpressumOption = .none, settingsSytleOption: SettingsSytleOption = .normal) {
        self.email = email
        self.licenseUsage = licenseUsage
        self.bundle = bundle
        self.creditsUsage = creditsUsage
        self.dataPrivacyUsage = dataPrivacyUsage
        self.questionsAndAnswers = questionsAndAnswers
        self.settingsSytleOption = settingsSytleOption
        self.impressumOption = impressumOption
    }

    var settingsIconColors: SettingsIconColors {
        return self.settingsSytleOption.settingsIconColors
    }

    var shouldShowLicense: Bool {
        switch self.licenseUsage {
        case .none:
            return false
        case .useGeneratedLicenses:
            return true
        }
    }

    func createLicenseViewModel() -> LicenseViewModel {
        return LicenseViewModel(licenseUsage: self.licenseUsage, bundle: self.bundle)
    }

    func createFeedbackViewModel() -> FeedbackViewModel {
        return FeedbackViewModel(contact: self.email)
    }

    func createCreditsViewModel() -> FileTextContentViewModel? {
        switch self.creditsUsage {
        case .useCredits(let settingsContent):
            return FileTextContentViewModel(file: settingsContent)
        case .none:
            return nil
        }
    }

    func createDataPrivacyViewModel() -> FileTextContentViewModel? {
        switch self.dataPrivacyUsage {
        case .useDataPrivacy(let settingsContent):
            return FileTextContentViewModel(file: settingsContent)
        case .none:
            return nil
        }
    }

    func createQuestionAndAnswerViewModel() -> QuestionAndAnswerViewModel? {
        guard self.questionsAndAnswers.count > 0 else { return nil }
        return QuestionAndAnswerViewModel(questionAndAnswers: self.questionsAndAnswers)
    }

    func createImpressumViewModel() -> ImpressumViewModel? {
        switch self.impressumOption {
        case .useImpressum(let contact):
            return ImpressumViewModel(contact: contact)
        case .none:
            return nil
        }
    }
}

public class LicenseViewModel: ObservableObject {
    private let licenseUsage: LicenseOption
    private let bundle: Bundle

    init(licenseUsage: LicenseOption, bundle: Bundle) {
        self.licenseUsage = licenseUsage
        self.bundle = bundle
    }

    func getLicenses() -> [License]? {
        switch self.licenseUsage {
        case .none:
            return nil
        case .useGeneratedLicenses:
            guard let urls = bundle.urls(forResourcesWithExtension: "license", subdirectory: "licenses") else { return nil }
            let licenses = urls.compactMap { url -> License? in
                guard let content = try? String(contentsOf: url)
                else { return nil }
                return License(title: url.deletingPathExtension().lastPathComponent, fullText: content)
            }.sorted(by: { $0.title.lowercased() < $1.title.lowercased() })
            return licenses
        }
    }
}
