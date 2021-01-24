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
                    FeedbackRow(feedbackViewModel: self.settings.createFeedbackViewModel(), color: self.settings.settingsIconColors.feedbackColor)
                }

                if let questionsAndAnswersViewModel = self.settings.createQuestionAndAnswerViewModel() {
                    Section(header: Label("FAQ", systemImage: "questionmark.circle.fill")) {
                        AllQuestionAndAnswersRowView(viewModel: questionsAndAnswersViewModel, color: self.settings.settingsIconColors.faqColor)
                    }
                }

                Section(header: Label("Legal", systemImage: "books.vertical.fill")) {
                    if self.settings.shouldShowLicense {
                        LicensesRow(
                            licenses: self.settings.createLicenseViewModel().getLicenses() ?? [],
                            color: self.settings.settingsIconColors.licenseColor
                        )
                    }
                    if let creditsViewModel = self.settings.createCreditsViewModel() {
                        CreditsRow(creditsViewModel: creditsViewModel, color: self.settings.settingsIconColors.creditsColor)
                    }
                    if let dataPrivacyViewModel = self.settings.createDataPrivacyViewModel() {
                        DataPrivacyRow(dataPrivacyViewModel: dataPrivacyViewModel, color: self.settings.settingsIconColors.dataPrivacyColor)
                    }
                }
                
                bottomFormContent()
                
                Section(footer: VersionFooterView(version: VersionFooterModel())) {
                    EmptyView()
                }
            }
            .navigationTitle("Settings")

            DetailNothingSelectedView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct DetailNothingSelectedView: View {
    @State private var isAnimating = false

    private let rotationAnimation = Animation.linear(duration: 30.0)
        .repeatForever(autoreverses: false)

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)

            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 100))
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                    .animation(rotationAnimation, value: isAnimating)
                    .onAppear {
                        self.isAnimating = true
                    }

                Text("Settings")
                    .bold()
                    .font(.largeTitle)
                Text("You can select an option in the Settings view.")
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            settings: SettingsConfiguration(
                email: "settings@whatthehack.com",
                creditsUsage: .useCredits(StaticTextContent(content: "Test")),
                dataPrivacyUsage: .useDataPrivacy(StaticTextContent(content: "Data Privacy")),
                questionsAndAnswers: [
                    QuestionAndAnswer(title: "What is this?", content: "This is a test.")
                ]))
            .environment(\.colorScheme, .dark)
    }
}
