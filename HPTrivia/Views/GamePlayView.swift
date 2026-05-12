//
//  GamePlayView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 12/05/26.
//

import SwiftUI

struct GamePlayView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: proxy.size.width * 3, height: proxy.size.height * 1.05)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.8))
                    }
                
                VStack {
                   // MARK: Controls
                   // MARK: Questions
                   // MARK: Hints
                   // MARK: Answers
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                
                //MARK: Celebration
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GamePlayView()
}
