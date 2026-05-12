//
//  GamePlayView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 12/05/26.
//

import SwiftUI
import AVKit

struct GamePlayView: View {
    
    @Environment(GameViewModel.self) private var gameViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
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
        .onAppear {
            gameViewModel.startGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                playMusic()
            }
        }
    }
}

private extension GamePlayView {
    
    private func playMusic() {
        let songs = ["let-the-mystery-unfold",
                     "spellcraft",
                     "hiding-place-in-the-forest",
                     "deep-in-the-dell"]
        let song = songs.randomElement()!
        guard let sound = Bundle.main.path(forResource: song, ofType: "mp3") else {
            print("Error while playing audio \(song).mp3")
            return
        }
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.1
            musicPlayer.play()
        } catch {
            print("Error while playing audio \(song).mp3")
        }
    }
    
    private func playFlipAudio() {
        guard let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3") else {
            print("Error while playing audio page-flip.mp3")
            return
        }
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            sfxPlayer.play()
        } catch {
            print("Error while playing audio page-flip.mp3")
        }
    }
    
    private func playWrongAnswerAudio() {
        guard let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3") else {
            print("Error while playing audio negative-beeps.mp3")
            return
        }
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            sfxPlayer.play()
        } catch {
            print("Error while playing audio negative-beeps.mp3")
        }
    }
    
    private func playCorrectAnswerAudio() {
        guard let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3") else {
            print("Error while playing audio magic-wand.mp3")
            return
        }
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            sfxPlayer.play()
        } catch {
            print("Error while playing audio magic-wand.mp3")
        }
    }
}

#Preview {
    GamePlayView()
        .environment(GameViewModel())
}
