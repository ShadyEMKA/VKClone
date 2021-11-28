//
//  NewsModel.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 13.11.21.
//

import UIKit

struct NewsModel: NewsCellViewModel {
    
    let postId: Int
    let icon: String
    let name: String
    let date: String
    let text: String?
    var moreTextButton: Bool
    let photoAttacments: PhotoAttachment?
    let likes: String?
    let likesUser: Bool
    let comments: String?
    let reposts: String?
    let views: String?
}

struct NewsPhotoAttachment: PhotoAttachment {
    
    let url: String
    let width: CGFloat
    let height: CGFloat
}


