//
//  ImageListService.swift
//  ImageFeed
//
//  Created by macOS on 20.01.2023.
//

import Foundation

final class ImageListService {
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = (lastLoadedPage ?? 0) + 1

        assert(Thread.isMainThread)
        
        task?.cancel()
                
        let request = makeRequest(path: "/photos?page=\(nextPage)", httpMethod: "GET", baseURL: DefaultBaseURL)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Array<PhotoResult>, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                for i in photoResult.indices {
                    let createdAt = photoResult[i].createdAt
                    let dateFormatter = ISO8601DateFormatter()
                    let date = dateFormatter.date(from: createdAt)
                    self.photos.append(
                        Photo(
                            id: photoResult[i].id,
                            size: CGSize(width: photoResult[i].width, height: photoResult[i].height),
                            createdAt: date,
                            welcomeDescription: photoResult[i].description,
                            thumbImageURL: photoResult[i].urls.thumb,
                            fullImageURL: photoResult[i].urls.full,
                            isLiked: photoResult[i].likedByUser))
                }
                NotificationCenter.default
                    .post(
                        name: ImageListService.didChangeNotification,
                        object: self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<VoidCodable, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request: URLRequest?
        if isLike {
            request = makeRequest(path: "/photos/\(photoId)/like", httpMethod: "POST", baseURL: DefaultBaseURL)
        } else {
            request = makeRequest(path: "/photos/\(photoId)/like", httpMethod: "DELETE", baseURL: DefaultBaseURL)
        }
        
        let task = urlSession.objectTask(for: request!) { [weak self] (result: Result<VoidCodable, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        fullImageURL: photo.fullImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    completion(result)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(result)
            }
        }
        self.task = task
        task.resume()
        
    }
    
    private func makeRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL) -> URLRequest {
            var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
            request.setValue("Bearer \(String(describing: OAuth2TokenStorage().token!))", forHTTPHeaderField: "Authorization")
            request.httpMethod = httpMethod
            
            return request
    }
}
