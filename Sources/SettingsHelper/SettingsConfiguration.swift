//
//  SettingsConfiguration.swift
//  SettingsHelper
//
//  Created by Yannick Rave on 17.01.21.
//

import Foundation

public enum LicenseOption {
    case useGeneratedLicenses, none
}


public class SettingsConfiguration {
    public var bundle: Bundle
    public var licenseUsage: LicenseOption
    public var email: String

    public init(email: String, licenseUsage: LicenseOption = .useGeneratedLicenses, bundle: Bundle = .main) {
        self.email = email
        self.licenseUsage = licenseUsage
        self.bundle = bundle
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
