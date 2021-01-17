import SwiftUI

public struct SettingsView: View {
    private let settings: SettingsConfiguration

    public init(settings: SettingsConfiguration) {
        self.settings = settings
    }

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Label("Contact", systemImage: "envelope.fill")) {
                    FeedbackRow(feedbackViewModel: self.settings.createFeedbackViewModel())
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                }
                
                Section(header: Label("Legal", systemImage: "books.vertical.fill")) {
                    if self.settings.shouldShowLicense {
                        LicensesRow(licenses: self.settings.createLicenseViewModel().getLicenses() ?? [])
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
        SettingsView(settings: SettingsConfiguration(email: "settings@whatthehack.com"))
    }
}

let mit = """
MIT License

Copyright (c) 2019 Point-Free, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
