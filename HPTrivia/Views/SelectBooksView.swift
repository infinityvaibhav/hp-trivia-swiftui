//
//  SelectBooksView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct SelectBooksView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(GameViewModel.self) var gameViewModel
    
    @State var showTempAlert = false
    
    var body: some View {
        ZStack {
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
            
            VStack {
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(gameViewModel.bookQuestions.books) { book in
                            switch book.status {
                            case .active:
                                SelectBookCellView(book: book, bookStatusImage: "checkmark.circle.fill")
                                    .onTapGesture {
                                        gameViewModel.bookQuestions.changeBookStatus(of: book.id, to: .inactive)
                                    }
                            case .inactive:
                                SelectBookCellView(book: book, bookStatusImage: "circle")
                                    .overlay {
                                        Rectangle().opacity(0.33)
                                    }
                                    .onTapGesture {
                                        gameViewModel.bookQuestions.changeBookStatus(of: book.id, to: .active)
                                    }
                            case .locked:
                                SelectBookCellView(book: book, bookStatusImage: "lock.fill")
                                    .overlay {
                                        Rectangle().opacity(0.5)
                                    }
                                    .onTapGesture {
                                        showTempAlert.toggle()
                                        gameViewModel.bookQuestions.changeBookStatus(of: book.id, to: .active)
                                    }
                            }
                        }
                    }
                    .padding()
                }
                
                Button("Done") {
                    dismiss()
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.brown.mix(with: .black, by: 0.2))
                .foregroundStyle(.white)
                .foregroundStyle(.black)
            }
        }
        .alert("You purchased a new question pack.", isPresented: $showTempAlert) {
            
        }
    }
}

#Preview {
    SelectBooksView()
        .environment(GameViewModel())
}
