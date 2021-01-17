import SwiftUI
import MessageUI

public struct SettingsView: View {
    let licenses: [License]
    public init(bundle: Bundle) {
        if let urls = bundle.urls(forResourcesWithExtension: "license", subdirectory: "licenses") {
            licenses = urls.compactMap { url -> License? in
                guard let content = try? String(contentsOf: url)
                else { return nil }
                return License(title: url.deletingPathExtension().lastPathComponent, fullText: content)
            }.sorted(by: { $0.title.lowercased() < $1.title.lowercased() })
        } else {
            licenses = []
        }
        
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Label("Contact", systemImage: "envelope.fill")) {
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                }
                
                Section(header: Label("Legal", systemImage: "books.vertical")) {
                    LicensesRow(licenses: licenses)
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                }
                
                Section(header: Label("Feedback", systemImage: "paperplane")) {
                    FeedbackRow()
                    Label("Something", systemImage: "circle")
                    Label("Something", systemImage: "circle")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

func loadLicenses(_ bundle: Bundle) -> [License] {
    []
}

struct LicensesRow: View {
    var licenses: [License]
    var title: LocalizedStringKey = "Licenses"
    var body: some View {
        NavigationLink(
            destination: LicensesPage(licenses: licenses)
                .navigationTitle(title),
            label: {
                Label(title, systemImage: "doc")
            })
    }
}

struct LicensesPage: View {
    var licenses: [License]
    var body: some View {
        List {
            ForEach(licenses) { license in
                LicenseDetails(license: license)
            }
        }.listStyle(InsetGroupedListStyle())
    }
}

struct License: Identifiable {
    var title: String
    var fullText: String
    
    var id: String { title }
}

struct LicenseDetails: View {
    @State private var isExpanded: Bool = false
    
    
    var license: License
    
    var body: some View {
        NavigationLink(
            destination: ScrollView { Text(license.fullText).padding() }
                .navigationTitle(license.title),
            label: {
                Label(license.title, systemImage: "doc")
            })
    }
}

struct FeedbackRow: View {
    
    var title: LocalizedStringKey = "Feedback"
    
    var body: some View {
        NavigationLink(
            destination: FeedbackView()
                .navigationTitle(title),
            label: {
                Label(title, systemImage: "circle")
            })
    }
}

enum Feedback: Identifiable {
    case feedback
    case reportProblem
    
    var contact: String { "dummyEmail@email.com" }
    
    var messageContent: (subject: String, message: String, recipient: String) {
        switch self {
        case .feedback:
            return ("Submit Feedback", "", self.contact)
        case .reportProblem:
            return ("Report a problem", "", self.contact)
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
    
    @State private var selectedOption: Feedback?
    
    // Not sure why this needs to be included
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        Form {
            
            Section {
                Button(action: {
                    selectedOption = .feedback
                }) {
                    Label("Submit Feedback", systemImage: "envelope")
                }
                .disabled(!MFMailComposeViewController.canSendMail())
                
            }
            
            Section {
                Button(action: {
                    selectedOption = .reportProblem
                }) {
                    Label("Report a problem", systemImage: "envelope")
                }
                .disabled(!MFMailComposeViewController.canSendMail())
            }
            
            Section(footer: Text("Select one of the options above.\n\nYour email will be sent to") + Text(" \(Feedback.feedback.contact)").fontWeight(.bold), content: {
                EmptyView()
            })
        }.sheet(item: $selectedOption) { content in
            MailView(result: self.$result, content: content).ignoresSafeArea(edges: .all)
        }
    }
    
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(bundle: .main)
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
