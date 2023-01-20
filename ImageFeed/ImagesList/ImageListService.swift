//
//  ImageListService.swift
//  ImageFeed
//
//  Created by macOS on 20.01.2023.
//

import Foundation

class ImageListService {
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage!.number + 1
    }
}
