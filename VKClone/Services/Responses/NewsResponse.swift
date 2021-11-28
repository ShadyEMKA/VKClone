//
//  NewsResponse.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 13.11.21.
//

import Foundation

struct NewsResponseWrapped: Decodable {
    
    let response: NewsResponse
}

struct NewsResponse: Decodable {
    
    var items: [News]
    var profiles: [Profile]
    let groups: [Group]
}

struct News: Decodable {
    
    let sourceId: Int
    let postId: Int
    let date: Double
    let text: String?
    let attachments: [Attachment]?
    let likes: CountableItem?
    let comments: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
}

struct Profile: Decodable, UserViewModel {

    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
    var avatar: String {
        return photo100
    }
    
}

struct Group: Decodable, UserViewModel {
    
    let id: Int
    let name: String
    let photo100: String
    var avatar: String {
        return photo100
    }
}

struct Attachment: Decodable {
    
    let photo: Photo?
}

struct Photo: Decodable {
    
    let id: Int
    let sizes: [PhotoSize]
    
    var height: Int {
        return getType().height
    }
    var width: Int {
        return  getType().width
    }
    var url: String {
        return getType().url
    }
    var type: String {
        return getType().type
    }
    
    private func getType() -> PhotoSize {
        if let type = sizes.first(where: {$0.type == "x"}) {
            return type
        } else if let typeFail = sizes.last {
            return typeFail
        } else {
            return PhotoSize(height: 0, width: 0, url: "", type: "")
        }
    }
}

struct PhotoSize: Decodable {
    
    let height: Int
    let width: Int
    let url: String
    let type: String
}

struct CountableItem: Decodable {
    
    let count: Int
    let userLikes: Int?
}
