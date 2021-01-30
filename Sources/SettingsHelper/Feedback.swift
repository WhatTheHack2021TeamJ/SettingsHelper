//
//  Feedback.swift
//  
//
//  Created by Yannick Rave on 17.01.21.
//

import SwiftUI
import MessageUI

struct FeedbackRow: View {
    @ObservedObject var feedbackViewModel: FeedbackViewModel
    var color: Color?

    var title: String = NSLocalizedString("Feedback", bundle: .module, comment: "")

    var body: some View {
        SettingsRow(title: self.title, systemImage: "envelope", color: self.color, destination: { FeedbackView(viewModel: self.feedbackViewModel) })
    }
}

class FeedbackViewModel: ObservableObject {
    @Published var contact: String
    @Published var selectedOption: Feedback?

    init(contact: String) {
        self.contact = contact
    }

    func createMailViewModel(feedback: Feedback) -> MailViewModel {
        return MailViewModel(feedback: feedback, contact: self.contact)
    }
}

class MailViewModel: ObservableObject {
    @Published var feedback: Feedback
    @Published var contact: String

    init(feedback: Feedback, contact: String) {
        self.feedback = feedback
        self.contact = contact
    }

    func messageContent() -> (subject: String, message: String, recipient: String) {
        return feedback.messageContent(contact: self.contact)
    }
}

enum Feedback: Identifiable {
    case feedback
    case reportProblem

    func messageContent(contact: String) -> (subject: String, message: String, recipient: String) {
        switch self {
        case .feedback:
            return (NSLocalizedString("Submit Feedback", bundle: .module, comment: ""), "", contact)
        case .reportProblem:
            return (NSLocalizedString("Report a problem", bundle: .module, comment: ""), "", contact)
        }
    }

    var id: Int {
        switch self {
        case .feedback: return 0
        case .reportProblem: return 1
        }
    }
}

struct FeedbackView: View {

    @ObservedObject var viewModel: FeedbackViewModel

    // Not sure why this needs to be included
    @State var result: Result<MFMailComposeResult, Error>? = nil

    var body: some View {
        Form {

            Section {
                Button(action: {
                    self.viewModel.selectedOption = .feedback
                }) {
                    CompatibleLabel(NSLocalizedString("Submit Feedback", bundle: .module, comment: ""), systemImage: "star")
                }
                .disabled(!MFMailComposeViewController.canSendMail())

            }

            Section {
                Button(action: {
                    self.viewModel.selectedOption = .reportProblem
                }) {
                    CompatibleLabel(NSLocalizedString("Report a problem", bundle: .module, comment: ""), systemImage: "ant")
                }
                .disabled(!MFMailComposeViewController.canSendMail())
            }

            Section(footer: Text("SelectOptionSendMailText", bundle: .module) + Text(self.viewModel.contact).fontWeight(.bold), content: {
                EmptyView()
            })
        }.sheet(item: self.$viewModel.selectedOption) { feedback in
            MailView(result: self.$result, viewModel: self.viewModel.createMailViewModel(feedback: feedback))
                .edgesIgnoringSafeArea(.all)
//                .ignoresSafeArea(edges: .all)
        }
    }

}
