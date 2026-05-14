//
//  GameViewModel.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//
import SwiftUI

@Observable
class GameViewModel {
    var bookQuestions = BookQuestions()
    
    var gameScore = 0
    var questionScore = 0
    var recentScores = [0, 0, 0]
    
    var activeQuestions: [Question] = []
    var answeredQuestions: [Int] = []
    var currentQuestion: Question?
    var answers: [String] = []
    
    let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "RecentScores")
    
    init() {
        loadInitialQuestion()
        loadScores()
    }
    
    private func loadInitialQuestion() {
        do {
            guard let url = Bundle.main.url(forResource: "trivia", withExtension: "json") else {
                print("Error: trivia.json file not found")
                return
            }
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)
            self.currentQuestion = questions.first
        } catch {
            print("Error loading initial question: \(error)")
        }
    }
    
    func startGame() {
        activeQuestions = bookQuestions.books
                            .filter { $0.status == .active }
                            .flatMap { $0.questions }
        newQuestion()
    }
    
    func newQuestion() {
        if answeredQuestions.count == activeQuestions.count {
            answeredQuestions = []
        }
        
        guard let randomQuestion = activeQuestions.randomElement() else {
            print("Error: No active questions available")
            return
        }
        
        currentQuestion = randomQuestion
        
        while let current = currentQuestion, answeredQuestions.contains(current.id) {
            if let newQuestion = activeQuestions.randomElement() {
                currentQuestion = newQuestion
            } else {
                break
            }
        }
        
        answers = []
        if let question = currentQuestion {
            answers.append(question.answer)
            for answer in question.wrong {
                answers.append(answer)
            }
        }
        
        answers.shuffle()
        questionScore = 5
    }
    
    func correct() {
        if let question = currentQuestion {
            answeredQuestions.append(question.id)
            withAnimation {
                gameScore += questionScore
            }
        }
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        saveSocres()
        
        gameScore = 0
        activeQuestions = []
        answeredQuestions = []
    }
    
    func saveSocres() {
        do {
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
    
    func loadScores() {
        do {
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            recentScores = [0, 0, 0]
        }
    }
}
