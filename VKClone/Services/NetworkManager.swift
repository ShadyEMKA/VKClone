//
//  NetworkManager.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getRequest(path: String, parameters: [String: String], completion: @escaping (Result<Data,Error>) -> Void) {
        guard let url = createURL(path: path, parameters: parameters) else {
            completion(.failure(NetworkError.unknownError))
            return
        }
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else {
                        completion(.failure(NetworkError.errorServer))
                        return
                    }
                    completion(.success(data))
                }
            }.resume()
    }
    
    private func createURL(path: String, parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        var allParameters = parameters
        allParameters["access_token"] = API.token
        allParameters["v"] = API.version
        urlComponents.scheme = API.scheme
        urlComponents.host = API.host
        urlComponents.path = path
        urlComponents.queryItems = allParameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents.url
    }
}
