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
    @Namespace private var namespace
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
    @State private var animateView = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var tappedWrongAnswers: [String] = []
    
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
                    HStack {
                        Button("End Game") {
                            gameViewModel.endGame()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        Spacer()
                        Text("Score: \(gameViewModel.gameScore)")
                    }
                    .padding()
                    .padding(.vertical, 30)
                    
                    // MARK: Questions
                    VStack {
                        if animateView {
                            Text(gameViewModel.currentQuestion!.question)
                                .font(.custom("PartyLetPlain", size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                .transition(.scale)
                        }
                    }
                    .animation(.easeInOut(duration: 2), value: animateView)
                    Spacer()
                    
                    // MARK: Hints
                    HStack {
                        VStack {
                            if animateView {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundStyle(.cyan)
                                    .padding()
                                    .transition(.offset(x: -proxy.size.width/2))
                                    .phaseAnimator([false, true]) { content, phase  in
                                        content.rotationEffect(.degrees(phase ? -13 : -18))
                                    } animation: { _ in
                                            .easeInOut(duration: 0.7)
                                    }.onTapGesture {
                                        withAnimation(.easeInOut(duration: 1)) {
                                            revealHint.toggle()
                                        }
                                        playFlipAudio()
                                        gameViewModel.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .offset(x: revealHint ? proxy.size.width/2 : 0)
                                    .opacity(revealHint ? 0 : 1)
                                    .overlay {
                                        if let hint = gameViewModel.currentQuestion?.hint {
                                            Text(hint)
                                                .padding(.leading, 20)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .opacity(revealHint ? 1  : 0)
                                                .scaleEffect(revealHint ? 1.33 : 1)
                                        }
                                    }
                            }
                        }
                        .animation(.easeInOut(duration: 1.5).delay(2), value: animateView)
                        
                        Spacer()
                        
                        VStack {
                            if animateView {
                                Image(systemName: "app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundStyle(.cyan)
                                    .padding()
                                    .overlay {
                                        Image(systemName: "book.closed")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50)
                                            .foregroundStyle(.black)
                                    }
                                    .transition(.offset(x: proxy.size.width/2))
                                    .phaseAnimator([false, true]) { content, phase  in
                                        content.rotationEffect(.degrees(phase ? 13 : 18))
                                    } animation: { _ in
                                            .easeInOut(duration: 0.7)
                                    }.onTapGesture {
                                        withAnimation(.easeInOut(duration: 1)) {
                                            revealBook.toggle()
                                        }
                                        playFlipAudio()
                                        gameViewModel.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? -1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .offset(x: revealBook ? -proxy.size.width/2 : 0)
                                    .opacity(revealBook ? 0 : 1)
                                    .overlay {
                                        if let book = gameViewModel.currentQuestion?.book {
                                            Image("hp\(book)")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(.trailing, 20)
                                                .opacity(revealBook ? 1  : 0)
                                                .scaleEffect(revealBook ? 1.33 : 1)
                                        }
                                    }
                            }
                        }
                        .animation(.easeInOut(duration: 1.5).delay(2), value: animateView)
                    }
                    .padding()
                
                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(gameViewModel.answers, id: \.self) { answer in
                            if answer == gameViewModel.currentQuestion?.answer {
                                VStack {
                                    if animateView {
                                        if !tappedCorrectAnswer {
                                            Button {
                                                withAnimation(.easeOut(duration: 1)) {
                                                    tappedCorrectAnswer.toggle()
                                                }
                                                playCorrectAnswerAudio()
                                                gameViewModel.correct()
                                            } label: {
                                                Text(answer)
                                                    .minimumScaleFactor(0.5)
                                                    .multilineTextAlignment(.center)
                                                    .padding(10)
                                                    .frame(width: proxy.size.width/2.15, height: 80)
                                                    .background(.green.opacity(0.5))
                                                    .clipShape(.rect(cornerRadius: 25))
                                                    .matchedGeometryEffect(id: 1, in: namespace)
                                            }
                                            .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 15).combined(with: .opacity)))
                                        }
                                    }
                                }
                                .animation(.easeInOut(duration: 1).delay(1.5), value: animateView)
                            } else {
                                VStack {
                                    if animateView {
                                        Button {
                                            withAnimation(.easeOut(duration: 1)) {
                                                tappedWrongAnswers.append(answer)
                                            }
                                            playWrongAnswerAudio()
                                            gameViewModel.questionScore -= 1
                                        } label: {
                                            Text(answer)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: proxy.size.width/2.15, height: 80)
                                                .background(tappedWrongAnswers.contains(answer) ? .red.opacity(0.5) : .green.opacity(0.5))
                                                .clipShape(.rect(cornerRadius: 25))
                                                .scaleEffect(tappedWrongAnswers.contains(answer) ? 0.8 : 1)
                                        }
                                        .transition(.scale)
                                        .sensoryFeedback(.error, trigger: tappedWrongAnswers)
                                        .disabled(tappedWrongAnswers.contains(answer))
                                    }
                                }
                                .animation(.easeInOut(duration: 1).delay(1.5), value: animateView)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                
                //MARK: Celebration
                VStack {
                    if tappedCorrectAnswer,
                       let correctAnswer = gameViewModel.currentQuestion?.answer {
                        Text(correctAnswer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: proxy.size.width/2.15, height: 80)
                            .background(.green.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 25))
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: 1, in: namespace)
                    }
                }
            }
            .foregroundStyle(.white)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            gameViewModel.startGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateView.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                playMusic()
            }
        }
    }
}

//MARK: Audio
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
