//
//  StoreViewModel.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 15/05/26.
//

import StoreKit

@MainActor
@Observable
class StoreViewModel {
    var products: [Product] = []
    var purchased = Set<String>()
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        self.updates = watchForUpdates()
    }
    
    // MARK: Load available products
    func loadProducts() async {
        do {
            products = try await Product.products(for: ["hp4", "hp5", "hp6", "hp7"])
            products.sort {
                $0.displayName < $1.displayName
            }
        } catch {
            print("Unable to load products: \(error)")
        }
    }
    
    // MARK: Purchase a product
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
                // Purchase successful, but now we need to verify receipt and transaction
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                    
                case .verified(let signedType):
                    purchased.insert(signedType.productID)
                    await signedType.finish()
                }
            // User cancelled or parent disapproved child's purchase request
            case .userCancelled:
                break
                
                // Waiting for some sort of approval
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("Unable to purchase product: \(error)")
        }
    }
    
    // TODO: Check for purchased product
    func checkPurchased() async {
        for product in products {
            guard let status = await product.currentEntitlement else { continue }
            
            switch status {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
            case .verified(let signedType):
                // product was purchased but somehow it was not cancelled or refunded and should be in purchased list else remove it
                if signedType.revocationDate == nil {
                    purchased.insert(signedType.productID)
                } else {
                    purchased.remove(signedType.productID)
                }
            }
        }
    }
    
    // TODO: Connect with App Store to watch for purchase and transaction updates
    func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
