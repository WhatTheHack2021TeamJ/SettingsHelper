//
//  File.swift
//  
//
//  Created by Yannick Rave on 28.01.21.
//

import SwiftUI

public struct CompatibleLabel: View {
    private let title: String
    private let name: String

    public init(_ title: String, systemImage name: String) {
        self.title = title
        self.name = name
    }

    public var body: some View {
        Group {
            if #available(iOS 14, *) {
                Label(title, systemImage: name)
            } else {
                HStack {
                    Image(systemName: name)
                    Text(title)
                }
            }
        }
    }
}

struct ListStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 14, *) {
                content
                    .listStyle(InsetGroupedListStyle())
            } else {
                content
                    .listStyle(GroupedListStyle())
            }
        }
    }
}

struct CompatibleNavigationTitle: ViewModifier {
    let title: String

    func body(content: Content) -> some View {
        Group {
            if #available(iOS 14, *) {
                content
                    .navigationTitle(self.title)
            } else {
                content
                    .navigationBarTitle(self.title)
            }
        }
    }
}
