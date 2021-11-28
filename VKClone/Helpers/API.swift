//
//  API.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import Foundation

class API {
    
    static let token = UserDefaults.standard.string(forKey: "token")
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
    static let friendsGet = "/method/friends.get"
    static let recommendFriendsGet = "/method/friends.getSuggestions"
    static let newsfeedGet = "/method/newsfeed.get"
    static let photosGet = "/method/photos.get"
    static let userGet = "/method/users.get"
}
