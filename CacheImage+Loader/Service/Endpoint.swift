//
//  Endpoint.swift
//  MVVM+Practice
//
//  Created by Murtaza Mehmood on 01/01/2023.
//

import Foundation


enum Endpoint {
    
    //BASE URL
    var BaseURL: URL{
        return URL(string: "https://fakestoreapi.com")!
    }
    
    //ENDPOINTS
    case Product
    
    
    var url: URL {
        switch self {
        case .Product:
            return BaseURL.appending(path: "products")
        }
    }
    
}
