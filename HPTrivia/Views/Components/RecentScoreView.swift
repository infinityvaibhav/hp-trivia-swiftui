//
//  RecentScoreView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct RecentScoreView: View {
    
    @Binding var animateViewIn: Bool
    @Environment(GameViewModel.self) private var gameViewModel
    
    var body: some View {
        VStack {
            if animateViewIn {
                VStack {
                    Text("Recent Scores")
                        .font(.title2)
                    ForEach(gameViewModel.recentScores, id: \.self) { score in
                        Text("\(score)")
                    }
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
        .environment(GameViewModel())
}
