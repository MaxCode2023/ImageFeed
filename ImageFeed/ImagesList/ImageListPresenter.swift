//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by macOS on 21.02.2023.
//

import Foundation

public protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImageListService { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
}

final class ImageListPresenter: ImageListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    var imagesListService = ImageListService()
    private var imageListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImageListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                
                let photos = self.imagesListService.photos
                self.view?.updateTableViewAnimated(photos: photos)
            }
    }

    internal func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
}
