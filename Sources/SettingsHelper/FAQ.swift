//
//  FAQ.swift
//
//
//  Created by Yannick Rave on 17.01.21.
//

import SwiftUI

struct AllQuestionAndAnswersRowView: View {
    @ObservedObject var viewModel: QuestionAndAnswerViewModel
    var color: Color?

    var title: String = NSLocalizedString("FAQ", bundle: .module, comment: "")

    var body: some View {
        SettingsRow(
            title: self.title, systemImage: "questionmark", color: self.color,
            destination: { AllQuestionAndAnswersView(viewModel: self.viewModel) })
    }
}

public struct QuestionAndAnswer: Identifiable {
    public let title: String
    public let content: String

    public init(
        title: String, content: String
    ) {
        self.title = title
        self.content = content
    }

    public var id: String { title }
}

class QuestionAndAnswerViewModel: ObservableObject {
    let questionAndAnswers: [QuestionAndAnswer]

    init(
        questionAndAnswers: [QuestionAndAnswer]
    ) {
        self.questionAndAnswers = questionAndAnswers
    }
}

struct SingleQuestionAndAnswerView: View {
    let questionAndAnswer: QuestionAndAnswer

    var body: some View {
        Group {
            if #available(iOS 14, *) {
                DisclosureGroup(
                    content: { Text(self.questionAndAnswer.content) },
                    label: { Text(self.questionAndAnswer.title) })
            } else {
                Section {
                    Text(self.questionAndAnswer.title)
                    Text(self.questionAndAnswer.content)
                }
            }
        }
    }
}

struct AllQuestionAndAnswersView: View {
    @ObservedObject var viewModel: QuestionAndAnswerViewModel

    var body: some View {
        Form {
            ForEach(
                self.viewModel.questionAndAnswers,
                content: {
                    SingleQuestionAndAnswerView(questionAndAnswer: $0)
                })
        }
    }
}

struct AllQuestionAndAnswersViewView_Previews: PreviewProvider {
    static var previews: some View {
        AllQuestionAndAnswersView(
            viewModel: QuestionAndAnswerViewModel(questionAndAnswers: [
                QuestionAndAnswer(title: "A", content: "B"),
                QuestionAndAnswer(title: "X", content: "Y"),
            ]))
    }
}
