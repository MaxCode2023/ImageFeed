//
//  ImageListService.swift
//  ImageFeed
//
//  Created by macOS on 20.01.2023.
//

import Foundation

class ImageListService {
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        
    }
}
