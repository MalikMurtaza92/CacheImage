//
//  Services.swift
//  MVVM+Practice
//
//  Created by Murtaza Mehmood on 01/01/2023.
//

import Foundation

public enum RequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

public enum NetworkingError: Error {
    case InvalidURL
    case ResponseError(Error?)
    case NoInternet
    case DecodingError(Error?)
}

protocol Networking {
    
    /// For calling API request
    ///
    /// You can use this method when you have to call HTTP request with query param.
    ///```
    ///func request(url: URL(string: "https://www.example.com")!,param:["id":id],model:Person.self,method: .GET) { result in
    ///     switch result {
    ///     case .succes(let model):
    ///         print(model)
    ///     case .failure(let error):
    ///         print(error)
    ///     }
    /// }
    ///```
    ///
    /// - Parameters:
    ///     - queryParam: query parameter for request
    ///     - body: request body
    ///     - method: HTTP method GET, POST, PUT, PATCH, DELETE
    ///     - headers: header for http request
    func request<T: Decodable>(url: URL,
                               queryParam: [String: Any]?,
                               body: Data?,
                               model: T.Type,
                               method: RequestMethod,
                               headers: [String: Any]?,
                               completion: @escaping ((Result<T,NetworkingError>)->Void))
    
    
    /// For calling API request
    ///
    /// You can use this method when you have to call HTTP request with query param without key. Just add values in param with range and this function will concat all param with url and make a request
    ///```
    ///func request(url: URL(string: "https://www.example.com")!,param:id,model:Person.self,method: .GET) { result in
    ///     switch result {
    ///     case .succes(let model):
    ///         print(model)
    ///     case .failure(let error):
    ///         print(error)
    ///     }
    /// }
    ///```
    ///
    /// - Parameters:
    ///     - params: query parameter for request without key
    ///     - body: request body
    ///     - method: HTTP method GET, POST, PUT, PATCH, DELETE
    ///     - headers: header for http request
    func request<T: Decodable>(url: URL,
                               params: String...,
                               body: Data?,
                               model: T.Type,
                               method: RequestMethod,
                               headers: [String: Any]?,
                               completion: @escaping ((Result<T,NetworkingError>)->Void))
}
