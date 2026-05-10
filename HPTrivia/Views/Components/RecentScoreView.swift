//
//  RecentScoreView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct RecentScoreView: View {
    
    @Binding var animateViewIn: Bool
    
    var body: some View {
        VStack {
            if animateViewIn {
                VStack {
                    Text("Recent Scores")
                        .font(.title2)
                    Text("33")
                    Text("27")
                    Text("15")
                }
                .font(.title3)
                .foregroundStyle(.white)
                .padding(.horizontal)
                .background(.black.opacity(0.7))
                .cornerRadius(15)
                .transition(.opacity)
            }
        }
        .animation(.linear(duration: 1).delay(0.7), value: animateViewIn)
    }
}

#Preview {
    RecentScoreView(animateViewIn: .constant(true))
}
