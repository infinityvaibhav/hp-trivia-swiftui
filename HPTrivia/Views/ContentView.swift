//
//  ContentView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateViewIn = false
    @State private var scalePlayButton = false
    @State private var playGame = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                HogwartsBackgroundView(proxy: proxy)
                VStack {
                    GameTitleView(animateViewIn: $animateViewIn)
                    Spacer()
                    RecentScoreView(animateViewIn: $animateViewIn)
                    Spacer()
                    HStack {
                        Spacer()
                        InstructionButton(animateViewIn: $animateViewIn,
                                          x: -proxy.size.height/3)
                        Spacer()
                        PlayButton(animateViewIn: $animateViewIn,
                                   playGame: $playGame,
                                   scalePlayButton: $scalePlayButton,
                                   y: proxy.size.height/3)
                        Spacer()
                        SettingsButton(animateViewIn: $animateViewIn,
                                       x: proxy.size.height/3)
                        Spacer()
                    }
                    .frame(width: proxy.size.width)
                    Spacer()
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewIn = true
            playAudioMagicInTheAir()
            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                scalePlayButton.toggle()
            }
        }
        .fullScreenCover(isPresented: $playGame) {
            GamePlayView()
                .onAppear {
                    audioPlayer.setVolume(0, fadeDuration: 2)
                }
                .onDisappear {
                    audioPlayer.setVolume(1, fadeDuration: 3)
                }
        }
    }
}

private extension ContentView {
    
    private func playAudioMagicInTheAir() {
        guard let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3") else {
            print("Error while playing audio magic-in-the-air.mp3")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            audioPlayer.numberOfLoops = -1
//            audioPlayer.play()
        } catch {
            print("Error while playing audio magic-in-the-air.mp3")
        }
    }
}

#Preview {
    ContentView()
        .environment(GameViewModel())
}
