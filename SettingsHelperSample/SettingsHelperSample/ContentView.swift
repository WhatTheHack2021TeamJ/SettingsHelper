//
//  ContentView.swift
//  SettingsHelperSample
//
//  Created by Joseph Van Boxtel on 1/16/21.
//

import SwiftUI
import SettingsHelper
import ConfettiView

struct ContentView: View {
    @State var isShowingConfetti = false

    var body: some View {
        ZStack {
            SettingsView(
                settings: SettingsConfiguration(
                    email: "test@test.com",
                    licenseUsage: .useGeneratedLicenses,
                    bundle: .main,
                    creditsUsage: .useCredits(StaticTextContent(content: "Thanks to everyone at WhatTheHack 2021 Hackathon 😊🎉")),
                    dataPrivacyUsage: .useDataPrivacy(StaticTextContent(content: "We sell all your data.")),
                    questionsAndAnswers:
                        [QuestionAndAnswer(title: "Who will win the prizes?", content: "Good question. That will be the settings framework.")]
                )
            ) {

                Button(action: {
                    self.isShowingConfetti.toggle()
                }, label: {
                    Text(isShowingConfetti ? "Stop showing confetti" : "Show me confetti!")
                })
            }

            if self.isShowingConfetti {
                ConfettiView( confetti: [
                                .text("🎉"),
                                .text("💪"),
                                .shape(.circle),
                                .shape(.triangle),
                            ])
                .onTapGesture {
                    self.isShowingConfetti = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
