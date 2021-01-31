//
//  SettingsRow.swift
//  
//
//  Created by Yannick Rave on 24.01.21.
//

import SwiftUI

public struct SettingsRow<Destination: View>: View {
    public let title: String
    public let systemImage: String
    public let destination: () -> Destination
    public let color: Color?

    public init(title: String, systemImage: String, color: Color?, @ViewBuilder destination: @escaping () -> Destination) {
        self.title = title
        self.systemImage = systemImage
        self.destination = destination
        self.color = color
    }

    public var body: some View {
        Group {
            if #available(iOS 14, *) {
                SettingsRowModifiedContent(content: SettingsRowContent(title: self.title, systemImage: self.systemImage, destination: self.destination), color: self.color)
            } else {
                SettingsRowContent(title: self.title, systemImage: self.systemImage, destination: self.destination)
            }
        }
    }
}

@available(iOS 14, *)
struct SettingsRowModifiedContent<V: View>: View {
    let content: SettingsRowContent<V>
    let color: Color?

    @ScaledMetric var size: CGFloat = 1

    var body: some View {
        content
            .modifier(SettingsRowModifier(size: self.size, color: self.color))
    }
}

struct SettingsRowContent<Destination: View>: View {
    let title: String
    let systemImage: String
    let destination: () -> Destination

    init(title: String, systemImage: String, @ViewBuilder destination: @escaping () -> Destination) {
        self.title = title
        self.systemImage = systemImage
        self.destination = destination
    }

    var body: some View {
        NavigationLink(
            destination: destination()
                .modifier(CompatibleNavigationTitle(title: title)),
            label: {
                CompatibleLabel(title, systemImage: systemImage)
            }
        )
    }
}
