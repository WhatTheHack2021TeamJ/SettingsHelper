import SwiftUI

public struct SettingsView<TopFormContent: View, BottomFormContent: View>: View {
    private let settings: SettingsConfiguration
    private let topFormContent: () -> TopFormContent
    private let bottomFormContent: () -> BottomFormContent

    public init(settings: SettingsConfiguration) where TopFormContent == EmptyView, BottomFormContent == EmptyView {
        self.settings = settings
        self.topFormContent = { EmptyView() }
        self.bottomFormContent = { EmptyView() }
    }

    public init(
        settings: SettingsConfiguration,
        @ViewBuilder topFormContent: @escaping () -> TopFormContent
    ) where BottomFormContent == EmptyView {
        self.settings = settings
        self.topFormContent = topFormContent
        self.bottomFormContent = { EmptyView() }
    }

    public init(
        settings: SettingsConfiguration,
        @ViewBuilder topFormContent: @escaping () -> TopFormContent,
        @ViewBuilder bottomFormContent: @escaping () -> BottomFormContent
    ) {
        self.settings = settings
        self.topFormContent = topFormContent
        self.bottomFormContent = bottomFormContent
    }

    public var body: some View {
        NavigationView {
            Form {
                topFormContent()
                Section(header: Label("Contact", systemImage: "envelope.fill")) {
                    FeedbackRow(feedbackViewModel: self.settings.createFeedbackViewModel())
                }

                Section(header: Label("Legal", systemImage: "books.vertical.fill")) {
                    if self.settings.shouldShowLicense {
                        LicensesRow(
                            licenses: self.settings.createLicenseViewModel().getLicenses() ?? [])
                    }
                    if let creditsViewModel = self.settings.createCreditsViewModel() {
                        CreditsRow(creditsViewModel: creditsViewModel)
                    }
                    if let dataPrivacyViewModel = self.settings.createDataPrivacyViewModel() {
                        DataPrivacyRow(creditsViewModel: dataPrivacyViewModel)
                    }
                    if let questionsAndAnswersViewModel = self.settings.createQuestionAndAnswerViewModel() {
                        AllQuestionAndAnswersRowView(viewModel: questionsAndAnswersViewModel)
                    }
                }
                
                bottomFormContent()
                
                Section(footer: VersionFooterView(version: VersionFooterModel())) {
                    EmptyView()
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
                email: "settings@whatthehack.com",
                creditsUsage: .useCredits(CreditsContent(content: "Test")),
                dataPrivacyUsage: .useDataPrivacy(CreditsContent(content: "Data Privacy")),
                questionsAndAnswers: [
                    QuestionAndAnswer(title: "What is this?", content: "This is a test.")
                ]))
            .environment(\.colorScheme, .dark)
    }
}
