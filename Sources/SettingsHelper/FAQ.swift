//
//  FAQ.swift
//
//
//  Created by Yannick Rave on 17.01.21.
//

import SwiftUI

struct AllQuestionAndAnswersRowView: View {
    @ObservedObject var viewModel: QuestionAndAnswerViewModel

    var title: LocalizedStringKey = "FAQ"

    var body: some View {
        NavigationLink(
            destination: AllQuestionAndAnswersView(viewModel: self.viewModel)
                .navigationTitle(title),
            label: {
                Label(title, systemImage: "questionmark")
            })
    }
}

public struct QuestionAndAnswer: Identifiable {
    public let title: String
    public let content: String

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
        DisclosureGroup(
            content: { Text(self.questionAndAnswer.content) },
            label: { Text(self.questionAndAnswer.title) })
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
        AllQuestionAndAnswersView(viewModel: QuestionAndAnswerViewModel(questionAndAnswers: [QuestionAndAnswer(title: "A", content: "B")]))
    }
}
