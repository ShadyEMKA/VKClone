//
//  NetworkDataFetcher.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit

class NetworkDataFetcher {
    
    static let shared = NetworkDataFetcher()
    
    func getFriends(completion: @escaping (Result<FriendsResponseWrapped,Error>) -> Void) {
        let parameters = ["order": "name", "fields": "first_name,last_name,photo_100,online"]
        NetworkManager.shared.getRequest(path: API.friendsGet, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let model = self.decodeJSON(type: FriendsResponseWrapped.self, data: data) else {
                    completion(.failure(NetworkError.errorDecodeJSON))
                    return
                }
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRecomendFriends(completion: @escaping (Result<FriendsResponseWrapped,Error>) -> Void) {
        let parameters = ["fields": "photo_100,online"]
        NetworkManager.shared.getRequest(path: API.recommendFriendsGet, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let model = self.decodeJSON(type: FriendsResponseWrapped.self, data: data) else {
                    completion(.failure(NetworkError.errorDecodeJSON))
                    return
                }
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPhotos(for id: Int?, completion: @escaping (Result<PhotosResponseWrapped,Error>) -> Void) {
        var parameters = ["album_id": "profile"]
        if let id = id {
            parameters["owner_id"] = String(id)
        }
        NetworkManager.shared.getRequest(path: API.photosGet, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let model = self.decodeJSON(type: PhotosResponseWrapped.self, data: data) else {
                    completion(.failure(NetworkError.errorDecodeJSON))
                    return
                }
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUser(for id: Int?, completion: @escaping (Result<UsersResponseWrapped,Error>) -> Void) {
        var parameters = ["fields": "photo_200"]
        if let id = id {
            parameters["id"] = String(id)
        }
        NetworkManager.shared.getRequest(path: API.userGet, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let model = self.decodeJSON(type: UsersResponseWrapped.self, data: data) else {
                    completion(.failure(NetworkError.errorDecodeJSON))
                    return
                }
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(type.self, from: data)
            return response
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
