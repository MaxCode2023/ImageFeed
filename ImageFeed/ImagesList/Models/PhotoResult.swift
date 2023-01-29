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
    let description: String
    let user: Array<String>
    let urls: UrlResult
    
}

struct UrlResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
