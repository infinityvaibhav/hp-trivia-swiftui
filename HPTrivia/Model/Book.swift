//
//  Book.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

struct Book: Identifiable {
    let id: Int
    let image: String
    let questions: [Question]
    let status: BookStatus
    
    enum BookStatus {
        case active, inactive, locked
    }
}
