//
//  ApiRest.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import Foundation
import Combine

class ApiRest {
    
    static let shared = ApiRest()
    private var urlSession = URLSession(configuration: .default)
    
    private init() { }
    
    func get<T: Decodable>(component: String,
                           queryItems: [URLQueryItem] = [URLQueryItem]()) -> AnyPublisher<T, Error>? {
        guard let fullUrl = Bookstastic.fullUrl?.appending(component: component) else { return nil }
        guard var urlComponents = URLComponents(url: fullUrl, resolvingAgainstBaseURL: true) else { return nil }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlSession.dataTaskPublisher(for: request).tryMap() {
            guard $0.data.count > 0 else { throw URLError(.zeroByteResource) }
            return $0.data
        }.decode(type: T.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func get(from url: String) -> AnyPublisher<Data, Error>? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return urlSession.dataTaskPublisher(for: request).tryMap() {
            guard $0.data.count > 0 else { throw URLError(.zeroByteResource) }
            return $0.data
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
