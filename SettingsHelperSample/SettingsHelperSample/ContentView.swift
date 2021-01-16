//
//  ContentView.swift
//  SettingsHelperSample
//
//  Created by Joseph Van Boxtel on 1/16/21.
//

import SwiftUI
import SettingsHelper

struct ContentView: View {
    var body: some View {
        SettingsView()
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
