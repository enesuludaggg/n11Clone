//
//  NetworkManager.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import Foundation

protocol NetworkManagerDelegate: AnyObject {
    func didFetchProducts(_ products: [Product], page: Int)
    func didFailWithError(_ error: Error)
}

class NetworkManager {
    static let shared = NetworkManager()
    weak var delegate: NetworkManagerDelegate?
    
    private let baseURL = "https://private-d3ae2-n11case.apiary-mock.com/listing/"
    
    func fetchProducts(page: Int) {
        let urlString = "\(baseURL)\(page)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ProductResponse.self, from: data)
                self.delegate?.didFetchProducts(result.products, page: page)
            } catch {
                self.delegate?.didFailWithError(error)
            }
        }.resume()
    }
}
