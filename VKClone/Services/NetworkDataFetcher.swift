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
    
    func getNews(completion: @escaping (Result<NewsResponseWrapped,Error>) -> Void) {
        let parameters = ["filters": "post,photo"]
        NetworkManager.shared.getRequest(path: API.newsfeedGet, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let dataJSON = try! JSONSerialization.jsonObject(with: data) as! NSDictionary
                
                let items = ((dataJSON.value(forKey: "response") as! NSDictionary).value(forKey: "items")) as! NSArray
                let profiles = ((dataJSON.value(forKey: "response") as! NSDictionary).value(forKey: "profiles")) as! NSArray
                let groups = ((dataJSON.value(forKey: "response") as! NSDictionary).value(forKey: "groups")) as! NSArray
                
                var newsResponseItem = [News]()
                var newsResponseProfile = [Profile]()
                var newsResponseGroup = [Group]()

                let requestQueue = DispatchGroup()
                
                DispatchQueue.global().async(group: requestQueue) {
                    for item in items {
                        let itemsData = try! JSONSerialization.data(withJSONObject: item)
                        guard let model = self.decodeJSON(type: News.self, data: itemsData) else {
                            completion(.failure(NetworkError.unknownError))
                            return
                        }
                        newsResponseItem.append(model)
                    }
                }
                DispatchQueue.global().async(group: requestQueue) {
                    for profile in profiles {
                        let profilesData = try! JSONSerialization.data(withJSONObject: profile)
                        guard let model = self.decodeJSON(type: Profile.self, data: profilesData) else {
                            completion(.failure(NetworkError.unknownError))
                            return
                        }
                        newsResponseProfile.append(model)
                    }
                }
                DispatchQueue.global().async(group: requestQueue) {
                    for group in groups {
                        let groupsData = try! JSONSerialization.data(withJSONObject: group)
                        guard let model = self.decodeJSON(type: Group.self, data: groupsData) else {
                            completion(.failure(NetworkError.unknownError))
                            return
                        }
                        newsResponseGroup.append(model)
                    }
                }

                requestQueue.notify(queue: DispatchQueue.main) {
                    let response = NewsResponse(items: newsResponseItem,
                                                profiles: newsResponseProfile,
                                                groups: newsResponseGroup)
                    let news = NewsResponseWrapped(response: response)
                    completion(.success(news))
                }
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
