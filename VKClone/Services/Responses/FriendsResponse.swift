//
//  FriendsResponse.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import Foundation

struct FriendsResponseWrapped: Decodable {
    
    let response: FriendResponse
}

struct FriendResponse: Decodable {
    
    let count: Int
    let items: [FriendItem]
}

struct FriendItem: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    let online: Int
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    var onlineBool: Bool {
        if online == 1 {
            return true
        } else if online == 0 {
            return false
        }
        return false
    }
}
