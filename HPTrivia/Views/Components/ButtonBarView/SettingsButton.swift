//
//  SettingsButton.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct SettingsButton: View {
    @Binding var animateViewIn: Bool
    @State var showSettings = false
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
        .sheet(isPresented: $showSettings) {
            SelectBooksView()
        }
    }
}

#Preview {
    GeometryReader { proxy in
        SettingsButton(animateViewIn: .constant(true), x: proxy.size.width/4)
            .environment(GameViewModel())
    }
}
