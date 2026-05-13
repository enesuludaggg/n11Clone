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

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    private var allVerticalProducts: [Product] = []
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
        if query.isEmpty {
            verticalProducts = allVerticalProducts
        } else {
            verticalProducts = allVerticalProducts.filter { $0.displayName.lowercased().contains(query.lowercased()) }
        }
        delegate?.didUpdateData()
    }
    
    func sortProducts(by type: Int) {
        switch type {
        case 0:
            verticalProducts = allVerticalProducts
        case 1:
            verticalProducts.sort { ($0.price ?? 0) < ($1.price ?? 0) }
        case 2:
            verticalProducts.sort { ($0.price ?? 0) > ($1.price ?? 0) }
        case 3: 
            verticalProducts.sort { ($0.rate ?? 0) > ($1.rate ?? 0) }
        default:
            break
        }
        delegate?.didUpdateData()
    }
}

extension HomeViewModel: NetworkManagerDelegate {
    func didFetchProducts(_ products: [Product], page: Int) {
        isFetching = false
        if page == 1 {
            self.horizontalProducts = Array(products.prefix(5))
            self.allVerticalProducts = Array(products.suffix(from: 5))
            self.verticalProducts = allVerticalProducts
        } else {
            self.allVerticalProducts.append(contentsOf: products)
            self.verticalProducts = allVerticalProducts
        }
        delegate?.didUpdateData()
    }
    func didFailWithError(_ error: Error) {
        isFetching = false
        delegate?.didError(error.localizedDescription)
    }
}
