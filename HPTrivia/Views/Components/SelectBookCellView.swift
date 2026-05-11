//
//  SelectBookCellView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 11/05/26.
//
import SwiftUI

struct SelectBookCellView: View {
    
    let book: Book
    @Environment(GameViewModel.self) var gameViewModel
    let bookStatusImage: String
    let opacity: Double
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(book.image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 10)
            
            Image(systemName: bookStatusImage)
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(.green)
                .shadow(radius: 1)
                .padding(5)
        }
        .overlay {
            Rectangle().opacity(opacity)
        }
    }
}
