//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

@main
struct HPTriviaApp: App {
    private var gameViewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gameViewModel)
        }
    }
}

/*
App Development plan
 🟨 Game Introduction plan
 - Gameplay screen
 - Game logic (question, scores, etc.)
 - Celebration
 🟨 Audio
 🟨 Animations
 - In App purchaes
 - Store
 ✅ Instructions screen
 🟨 Books
 - Persist scores
*/
