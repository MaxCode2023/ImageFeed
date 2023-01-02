//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by macOS on 02.01.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
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
                self.avatarURL = body.profile_image.small
                completion(.success(body.profile_image.small))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL!])
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        
//        let task = object(for: request) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let body):
//                self.avatarURL = body.profile_image.small
//                completion(.success(body.profile_image.small))
//                NotificationCenter.default
//                    .post(
//                        name: ProfileImageService.DidChangeNotification,
//                        object: self,
//                        userInfo: ["URL": self.avatarURL!])
//            case .failure(let error):
//                print(error)
//                completion(.failure(error))
//            }
//        }
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

//extension ProfileImageService {
//    private func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
//
//        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if 200 ..< 300 ~= statusCode {
//                    DispatchQueue.main.async {
//                        completion(.success(data))
//                        self.task = nil
//                        if error != nil {
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(.failure(NetworkError.httpStatusCode(statusCode)))
//                    }
//                }
//            } else if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(NetworkError.urlRequestError(error)))
//                }
//            } else {
//                DispatchQueue.main.async {
//                    completion(.failure(NetworkError.urlSessionError))
//                }
//            }
//        })
//        task.resume()
//        return task
//    }
//
//    private func object(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<UserResult, Error> in
//                Result { try decoder.decode(UserResult.self, from: data) }
//            }
//            completion(response)
//        }
//    }
//}

struct UserResult: Codable {
    let profile_image: ImageResult
}

struct ImageResult: Codable {
    let small: String
    let medium: String
    let large: String
}

