//
//  BookQuestions.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//
import Foundation

@Observable
class BookQuestions {
    var books: [Book] = []
    
    let booksStatusSavePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "BooksStatus")
    
    init() {
        loadBookStatus()
    }
    
    private func decodeQuestions() -> [Question] {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode([Question].self, from: data)
            } catch {
                print("Error decoding json data: \(error)")
            }
        }
        return []
    }
    
    private func organizeQuestions(_ questions: [Question]) -> [[Question]] {
        var organizedQuestions: [[Question]] = [[], [], [], [], [], [], [], []]
        
        for question in questions {
            organizedQuestions[question.book].append(question)
        }
        return organizedQuestions
    }
    
    private func populabeBooks(from questions: [[Question]]) {
        books.append(Book(id: 1, image: "hp1", questions: questions[1], status: .active))
        books.append(Book(id: 2, image: "hp2", questions: questions[2], status: .active))
        books.append(Book(id: 3, image: "hp3", questions: questions[3], status: .inactive))
        books.append(Book(id: 4, image: "hp4", questions: questions[4], status: .locked))
        books.append(Book(id: 5, image: "hp5", questions: questions[5], status: .locked))
        books.append(Book(id: 6, image: "hp6", questions: questions[6], status: .locked))
        books.append(Book(id: 7, image: "h76", questions: questions[7], status: .locked))
    }
    
    func changeBookStatus(of id: Int, to status: BookStatus) {
        books[id-1].status = status
    }
    
    func saveBookStatus() {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: booksStatusSavePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
    
    func loadBookStatus() {
        do {
            let data = try Data(contentsOf: booksStatusSavePath)
            books = try JSONDecoder().decode([Book].self, from: data)
        } catch {
            let questions = decodeQuestions()
            let organizedQuestions = organizeQuestions(questions)
            populabeBooks(from: organizedQuestions)
        }
    }
}

