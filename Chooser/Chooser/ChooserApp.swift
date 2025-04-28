//
//  ChooserApp.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 26.04.2025.
//

import SwiftUI
import FirebaseCore

@main
struct ChooserApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

