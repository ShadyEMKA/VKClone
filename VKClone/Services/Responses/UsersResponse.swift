//
//  UsersResponse.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 17.11.21.
//

import Foundation

struct UsersResponseWrapped: Decodable {
    
    let response: [UsersResponse]?
    let error: ErrorResponse?
}

struct UsersResponse: Decodable {
    
    let id: Int
    let firstName: String
    let lastName: String
    let photo200: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

struct ErrorResponse: Decodable {
    
    let errorCode: Int
}
