//
//  SwahiLibApp.swift
//  SwahiLib
//
//  Created by Siro Daves on 29/04/2025.
//

import SwiftUI

@main
struct SwahiLibApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(prefsRepo: PrefsRepository())
        }
    }
}
