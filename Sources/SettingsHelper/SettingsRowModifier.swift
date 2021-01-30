//
//  SettingsRowModifier.swift
//  
//
//  Created by Yannick Rave on 24.01.21.
//

import SwiftUI

@available(iOS 14, *)
public struct ColorfulIconLabelStyle: LabelStyle {
    public var color: Color
    public var size: CGFloat

    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 5 * size).frame(width: 30 * size, height: 30 * size).foregroundColor(color))
        }
    }
}

@available(iOS 14, *)
public struct SettingsRowModifier: ViewModifier {
    @ScaledMetric var size: CGFloat = 1
    let color: Color?

    public func body(content: Content) -> some View {
        Group {
            if let color = self.color {
                content
                    .labelStyle(ColorfulIconLabelStyle(color: color, size: size))
            } else {
                content
            }
        }
    }
}
