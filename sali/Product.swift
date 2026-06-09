//
//  Product.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int?
    let title: String?
    let name: String?
    let price: Double?
    let rate: Double?
    let image: String?
    
    var displayName: String {
        return title ?? name ?? "İsimsiz Ürün"
    }
    
    var formattedPrice: String {
        if let price = price {
            return "\(price) TL"
        }
        return "0 TL"
    }
}
