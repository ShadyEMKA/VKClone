//
//  PhotosResponse.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 16.11.21.
//

import Foundation

struct PhotosResponseWrapped: Decodable {
    
    let response: PhotosResponse
}

struct PhotosResponse: Decodable {
    
    let count: Int
    let items: [PhotoItem]
}

struct PhotoItem: Decodable {
    
    let id: Int
    let sizes: [PhotoSizeItem]
    var url: String {
        return getType().url
    }
    
    private func getType() -> PhotoSizeItem {
        if let type = sizes.first(where: {$0.type == "x"}) {
            return type
        } else if let typeFail = sizes.last {
            return typeFail
        } else {
            return PhotoSizeItem(url: "", type: "")
        }
    }
}

struct PhotoSizeItem: Decodable {
    
    let url: String
    let type: String
}

