import SwiftUI

public struct SettingsView<Content: View>: View {
    private let settings: SettingsConfiguration
    private let content: () -> Content

    public init(settings: SettingsConfiguration) where Content == EmptyView {
        self.settings = settings
        self.content = { EmptyView() }
    }

    public init(
        settings: SettingsConfiguration,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.settings = settings
        self.content = content
    }

    public var body: some View {
        NavigationView {
            Form {
                content()
                Section(header: Label("Contact", systemImage: "envelope.fill")) {
                    FeedbackRow(feedbackViewModel: self.settings.createFeedbackViewModel())
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                }

                Section(header: Label("Legal", systemImage: "books.vertical.fill")) {
                    if self.settings.shouldShowLicense {
                        LicensesRow(
                            licenses: self.settings.createLicenseViewModel().getLicenses() ?? [])
                    }
                    if let creditsViewModel = self.settings.createCreditsViewModel() {
                        CreditsRow(creditsViewModel: creditsViewModel)
                    }
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                }
            }
            .navigationTitle("Settings")
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            settings: SettingsConfiguration(
                email: "settings@whatthehack.com", creditsUsage: .useCredits(CreditsContent(content: "Test"))))
    }
}
