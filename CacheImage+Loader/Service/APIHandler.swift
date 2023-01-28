//
//  APIHandler.swift
//  MVVM+Practice
//
//  Created by Murtaza Mehmood on 01/01/2023.
//

import Foundation

public class APIHandler: Networking {
    
    private var session: URLSession!
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        self.init(configuration: configuration)
    }
    
    private func addQueryParam(url: URL,queryParam: [String: Any]) -> URL? {
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = queryParam.map({URLQueryItem(name: $0.key, value: $0.value as? String)})
        guard let requestedURL = urlComponent?.url else {
            return nil
        }
        return requestedURL
    }
    
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
    public func request<T>(url: URL,
                    queryParam: [String : Any]? = nil,
                    body: Data? = nil,
                    model: T.Type,
                    method: RequestMethod,
                    headers: [String : Any]? = nil,
                    completion: @escaping ((Result<T, NetworkingError>) -> Void)) where T : Decodable {
        
        var request: URLRequest!
        
        if let params = queryParam {
            guard let requestedURL = addQueryParam(url: url, queryParam: params) else {
                completion(.failure(.InvalidURL))
                return
            }
            request = URLRequest(url: requestedURL)
        } else {
            request = URLRequest(url: url)
        }
        request.httpBody = body
        request.httpMethod = method.rawValue
        if let headers = headers {
            request.allHTTPHeaderFields = headers.compactMapValues({$0 as? String})
        }
        
        guard NetworkReachabilityManager.isConnectedToNetwork() else {
            completion(.failure(.NoInternet))
            return
        }
        
        self.request(request: request, model: model, completion: completion)
    }
    
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
    public func request<T>(url: URL,
                    params: String...,
                    body: Data? = nil,
                    model: T.Type,
                    method: RequestMethod,
                    headers: [String : Any]? = nil,
                    completion: @escaping ((Result<T, NetworkingError>) -> Void)) where T : Decodable {
        
        var request: URLRequest!
        
        
        if params.isEmpty {
            request = URLRequest(url: url)
        } else {
            var requestedURL = url
            params.forEach({requestedURL = requestedURL.appending(path: $0)})
            request = URLRequest(url: requestedURL)
        }
        
        request.httpBody = body
        request.httpMethod = method.rawValue
        if let headers = headers {
            request.allHTTPHeaderFields = headers.compactMapValues({$0 as? String})
        }

        guard NetworkReachabilityManager.isConnectedToNetwork() else {
            completion(.failure(.NoInternet))
            return
        }

        self.request(request: request, model: model, completion: completion)
    }
    
    
    /// Calling HTTP request using URLSession class
    ///
    ///
    ///  - Parameters:
    ///     - request: A URL request object that provides the URL, cache policy, request type, body data or body stream, and so on.
    ///     - model: Type which is comming from API response and decode inside the function using JSON decoder
    private func request<T: Decodable>(request: URLRequest,model: T.Type,completion: @escaping ((Result<T,NetworkingError>)->Void)) {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.ResponseError(error)))
                }
                return
            }
            
            if let response = (response as? HTTPURLResponse), 200 ... 299 ~= response.statusCode {
                do {
                    let model = try JSONDecoder().decode(T.self, from: data!)
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(.DecodingError(error)))
                    }
                }
                
            }
            DispatchQueue.main.async {
                completion(.failure(.ResponseError(error)))
            }
        }
        
        task.resume()
    }
}

