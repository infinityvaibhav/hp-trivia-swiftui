//
//  InstructionButton.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct InstructionButton: View {
    @Binding var animateViewIn: Bool
    @State var showInstructions: Bool = false
    let x: Double
    var body: some View {
        VStack {
            if animateViewIn {
                Button {
                    showInstructions.toggle()
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                }
                .transition(.offset(x: x))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(0.2), value: animateViewIn)
        .sheet(isPresented: $showInstructions) {
            InstructionsView()
        }
    }
}
