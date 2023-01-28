//
//  ProductViewModel.swift
//  MVVM+Practice
//
//  Created by Murtaza Mehmood on 01/01/2023.
//

import Foundation

class ProductViewModel {
    
    private var networking: Networking
    var products: [Product]
    
    var fetchProductsCompletion: ((NetworkingError?)->Void)?
    
    init(networking: Networking) {
        self.networking = networking
        self.products = []
        getProducts()
    }
    
    func getProduct(index: Int) -> Product? {
        guard self.products.indices.contains(index) else {return nil}
        return products[index]
    }
    
    func getProducts() {
        networking.request(url: Endpoint.Product.url, queryParam: nil, body: nil, model: [Product].self, method: .GET, headers: nil) { result in
            switch result {
            case .success(let model):
                self.products = model
                self.fetchProductsCompletion?(nil)
            case .failure(let error):
                self.fetchProductsCompletion?(error)
            }
        }
    }
    
}
