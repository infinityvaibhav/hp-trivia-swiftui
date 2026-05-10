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
    @State private var showInstructions = false
    @State private var showSettings = false
    @State private var playGame = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                hogwartsBackground(proxy: proxy)
                VStack {
                    titleView
                    Spacer()
                    Spacer()
                    Spacer()
                    HStack {
                        Spacer()
                        instructionButton(x: -proxy.size.height/3)
                        Spacer()
                        playButton(y: proxy.size.height/3)
                        Spacer()
                        settingsButton(x: proxy.size.height/3)
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
//            playAudioMagicInTheAir()
            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                scalePlayButton.toggle()
            }
        }
        .sheet(isPresented: $showInstructions) {
            InstructionsView()
        }
    }
}

extension ContentView {
    
    func hogwartsBackground(proxy: GeometryProxy) -> some View {
        Image(.hogwarts)
            .resizable()
            .frame(width: proxy.size.width * 3, height: proxy.size.height)
            .padding(.top)
            .phaseAnimator([false, true]) { content, phase in
                content
                    .offset(x: phase ? proxy.size.width/1.1 : -proxy.size.width/1.1)
            } animation: { _ in
                    .linear(duration: 60)
            }
    }
    
    var titleView: some View {
        VStack {
            if animateViewIn {
                VStack {
                    Image(systemName: "bolt.fill")
                        .imageScale(.large)
                        .font(.largeTitle)
                    Text("HP")
                        .font(.custom("PartyLetPlain", size: 70))
                        .padding(.bottom, -50)
                    
                    Text("Trivia")
                        .font(.custom("PartyLetPlain", size: 60))
                }
                .padding(.top, 70)
                .transition(.move(edge: .top))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(0.2), value: animateViewIn)
    }
    
    func playButton(y: Double) -> some View {
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
    
    private func playAudioMagicInTheAir() {
        guard let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3") else {
            print("Error while playing audio magic-in-the-air.mp3")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        } catch {
            print("Error while playing audio magic-in-the-air.mp3")
        }
    }
    
    func instructionButton(x: Double) -> some View {
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
    }
    
    func settingsButton(x: Double) -> some View {
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

#Preview {
    ContentView()
}
