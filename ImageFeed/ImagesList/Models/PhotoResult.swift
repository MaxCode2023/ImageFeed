//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Albert on 29.01.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let user: UserResult
    let urls: UrlResult
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blurHash = "blur_hash"
        case likedByUser = "liked_by_user"
        case description = "description"
        case user = "user"
        case urls = "urls"
        case id = "id"
        case width = "width"
        case height = "height"
        case color = "color"
        case likes = "likes"
    }
    
}

struct UrlResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

