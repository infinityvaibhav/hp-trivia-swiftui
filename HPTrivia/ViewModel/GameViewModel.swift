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
    var currentQuestion: Question = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
    var answers: [String] = []
    
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
        
        currentQuestion = activeQuestions.randomElement()!
        
        while(answeredQuestions.contains(currentQuestion.id)) {
            currentQuestion = activeQuestions.randomElement()!
        }
        
        answers = []
        answers.append(currentQuestion.answer)
        for answer in currentQuestion.wrongAnswer {
            answers.append(answer)
        }
        
        answers.shuffle()
        questionScore = 5
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        
        gameScore += questionScore
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        gameScore = 0
        activeQuestions = []
        answeredQuestions = []
    }
}
