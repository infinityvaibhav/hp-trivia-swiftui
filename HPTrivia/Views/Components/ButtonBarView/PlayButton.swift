//
//  PlayButton.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct PlayButton: View {
    @Binding var animateViewIn: Bool
    @State private var playGame = false
    @Binding var scalePlayButton: Bool
    let y: Double
    var body: some View {
        VStack {
            if animateViewIn {
                Button {
                    playGame.toggle()
                } label: {
                    Text("Play")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 50)
                        .background(.brown)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(radius: 10)
                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                }
                .transition(.offset(y: y))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(0.2), value: animateViewIn)
    }
}
