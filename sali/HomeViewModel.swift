//
//  HomeViewModelDelegate.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func didUpdateData()
    func didError(_ message: String)
}

enum ProductSortOption {
    case smart
    case priceAscending
    case priceDescending
    case ratingDescending
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    var allVerticalProducts: [Product] = []
    var horizontalProducts: [Product] = []
    var verticalProducts: [Product] = []
    private var currentPage = 1
    private var isFetching = false
    
    init() {
        NetworkManager.shared.delegate = self
    }
    
    func loadData() {
        NetworkManager.shared.fetchProducts(page: 1)
    }
    
    func loadNextPage() {
        guard !isFetching else { return }
        currentPage += 1
        if currentPage <= 2 {
            NetworkManager.shared.fetchProducts(page: currentPage)
        }
    }
    
    func search(query: String) {
        guard !query.isEmpty else {
            verticalProducts = allVerticalProducts
            delegate?.didUpdateData()
            return
        }
        
        verticalProducts = allVerticalProducts.filter { $0.displayName.lowercased().contains(query.lowercased()) }
        delegate?.didUpdateData()
    }
    
    func sortProducts(by option: ProductSortOption) {
        switch option {
        case .smart:
            verticalProducts = allVerticalProducts
            
        case .priceAscending:
            verticalProducts.sort { ($0.price ?? 0) < ($1.price ?? 0) }
            
        case .priceDescending:
            verticalProducts.sort { ($0.price ?? 0) > ($1.price ?? 0) }
            
        case .ratingDescending:
            verticalProducts.sort { ($0.rate ?? 0) > ($1.rate ?? 0) }
        }
        
        delegate?.didUpdateData()
    }
}

extension HomeViewModel: NetworkManagerDelegate {
    func didFetchProducts(_ products: [Product], page: Int) {
        isFetching = false
        handleFetchedProducts(products, page: page)
    }

    func didFailWithError(_ error: Error) {
        isFetching = false
        delegate?.didError(error.localizedDescription)
    }
    
    private func handleFetchedProducts(_ products: [Product], page: Int) {
        if page == 1 {
            self.horizontalProducts = Array(products.prefix(5))
            self.allVerticalProducts = products
        } else {
            self.allVerticalProducts.append(contentsOf: products)
        }
        self.verticalProducts = allVerticalProducts
        delegate?.didUpdateData()
    }
}
