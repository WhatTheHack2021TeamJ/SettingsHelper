//
//  SettingsRow.swift
//  
//
//  Created by Yannick Rave on 24.01.21.
//

import SwiftUI

public struct SettingsRow<Destination: View>: View {
    @ScaledMetric var size: CGFloat = 1

    public let title: LocalizedStringKey
    public let systemImage: String
    public let destination: () -> Destination
    public let color: Color?

    public init(title: LocalizedStringKey, systemImage: String, color: Color?, @ViewBuilder destination: @escaping () -> Destination) {
        self.title = title
        self.systemImage = systemImage
        self.destination = destination
        self.color = color
    }

    public var body: some View {
        NavigationLink(
            destination: destination()
                .navigationTitle(title),
            label: {
                Label(title, systemImage: systemImage)
            }
        )
        .modifier(SettingsRowModifier(color: self.color, size: self.size))
    }
}
