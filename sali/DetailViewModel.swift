//
//  DetailViewModel.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import Foundation

class DetailViewModel {
    let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var title: String { product.displayName }
    var price: String { "\(product.price ?? 0.0)".withTL }
    var rateText: String { "\(product.rate ?? 0.0)" }
    var imageUrl: String? { product.image }
}

extension String {
    var withTL: String {
        return "\(self) TL"
    }
}
