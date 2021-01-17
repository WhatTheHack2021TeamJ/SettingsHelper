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

    var title: LocalizedStringKey = "Feedback"

    var body: some View {
        NavigationLink(
            destination: FeedbackView(viewModel: self.feedbackViewModel)
                .navigationTitle(title),
            label: {
                Label(title, systemImage: "envelope")
            })
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
            return ("Submit Feedback", "", contact)
        case .reportProblem:
            return ("Report a problem", "", contact)
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

    @State var viewModel: FeedbackViewModel

    // Not sure why this needs to be included
    @State var result: Result<MFMailComposeResult, Error>? = nil

    var body: some View {
        Form {

            Section {
                Button(action: {
                    self.viewModel.selectedOption = .feedback
                }) {
                    Label("Submit Feedback", systemImage: "star")
                }
                .disabled(!MFMailComposeViewController.canSendMail())

            }

            Section {
                Button(action: {
                    self.viewModel.selectedOption = .reportProblem
                }) {
                    Label("Report a problem", systemImage: "ant")
                }
                .disabled(!MFMailComposeViewController.canSendMail())
            }

            Section(footer: Text("Select one of the options above.\n\nYour email will be sent to") + Text(" \(self.viewModel.contact)").fontWeight(.bold), content: {
                EmptyView()
            })
        }.sheet(item: self.$viewModel.selectedOption) { feedback in
            MailView(result: self.$result, viewModel: self.viewModel.createMailViewModel(feedback: feedback)).ignoresSafeArea(edges: .all)
        }
    }

}
