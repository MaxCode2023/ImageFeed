//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by macOS on 02.01.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        let request = makeRequest(path: "/users/\(username)", httpMethod: "GET", baseURL: DefaultBaseURL)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                self.avatarURL = body.profileImage.small
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL!])
                completion(.success(body.profileImage.small))
            case .failure(let error):
                print(error)
                completion(.failure(error))
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

struct UserResult: Codable {
    let profileImage: ImageResult
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageResult: Codable {
    let small: String
    let medium: String
    let large: String
}

