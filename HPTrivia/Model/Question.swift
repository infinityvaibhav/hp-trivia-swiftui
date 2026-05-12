//
//  Question.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

struct Question: Decodable {
    let id: Int
    let question: String
    let answer: String
    let wrong: [String]
    let book: Int
    let hint: String
}
