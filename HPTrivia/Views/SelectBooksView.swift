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
    
    private var storeViewModel = StoreViewModel()
    
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
                                SelectBookCellView(book: book,
                                                   bookStatusImage: "checkmark.circle.fill",
                                                   opacity: 0)
                                    .onTapGesture {
                                        gameViewModel.bookQuestions.changeBookStatus(of: book.id, to: .inactive)
                                    }
                            case .inactive:
                                SelectBookCellView(book: book,
                                                   bookStatusImage: "circle",
                                                   opacity: 0.33)
                                    .onTapGesture {
                                        gameViewModel.bookQuestions.changeBookStatus(of: book.id, to: .active)
                                    }
                            case .locked:
                                if storeViewModel.purchased.contains(book.image) {
                                    SelectBookCellView(book: book,
                                                       bookStatusImage: "checkmark.circle.fill",
                                                       opacity: 0)
                                    .onTapGesture {
                                        gameViewModel.bookQuestions.changeBookStatus(of: book.id, to: .inactive)
                                    }
                                    .task {
                                        gameViewModel.bookQuestions.changeBookStatus(of: book.id, to: .active)
                                    }
                                } else {
                                    SelectBookCellView(book: book,
                                                       bookStatusImage: "lock.fill",
                                                       opacity: 0.5)
                                    .onTapGesture {
                                        let product = storeViewModel.products[book.id-4]
                                        Task {
                                            await storeViewModel.purchase(product)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if !activeBooks {
                    Text("You must select atleast one book")
                        .multilineTextAlignment(.center)
                }
                
                Button("Done") {
                    gameViewModel.bookQuestions.saveBookStatus()
                    dismiss()
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.brown.mix(with: .black, by: 0.2))
                .foregroundStyle(.white)
                .foregroundStyle(.black)
                .disabled(!activeBooks)
            }
        }
        .interactiveDismissDisabled()
        .task {
            await storeViewModel.loadProducts()
        }
    }
    
    var activeBooks: Bool {
        gameViewModel.bookQuestions.books.contains { $0.status == .active }
    }
}

#Preview {
    SelectBooksView()
        .environment(GameViewModel())
}
