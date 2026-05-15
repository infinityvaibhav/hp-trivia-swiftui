//
//  Book.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

struct Book: Identifiable, Codable {
    let id: Int
    let image: String
    let questions: [Question]
    var status: BookStatus
}

enum BookStatus: Codable {
    case active, inactive, locked
}
