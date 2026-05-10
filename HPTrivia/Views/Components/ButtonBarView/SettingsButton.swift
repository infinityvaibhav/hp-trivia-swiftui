//
//  SettingsButton.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct SettingsButton: View {
    @Binding var animateViewIn: Bool
    @Binding var showSettings: Bool
    let x: Double
    var body: some View {
        VStack {
            if animateViewIn {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                }
                .transition(.offset(x: x))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(0.2), value: animateViewIn)
    }
}
