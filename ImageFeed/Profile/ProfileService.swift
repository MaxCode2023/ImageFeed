//
//  ProfileService.swift
//  ImageFeed
//
//  Created by macOS on 02.01.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfile(completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        let request = makeRequest(path: "/me", httpMethod: "GET", baseURL: DefaultBaseURL)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                self.profile = Profile(result: body)
                completion(.success(body))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        
//        let task = object(for: request) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let body):
//                self.profile = Profile(result: body)
//                completion(.success(body))
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

//extension ProfileService {
//    private func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
//        
//        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if 200 ..< 300 ~= statusCode {
//                    DispatchQueue.main.async {
//                        completion(.success(data))
//                        self.task = nil
//                        if error != nil {
//                          //  self.lastCode = nil
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
//    private func object(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<ProfileResult, Error> in
//                Result { try decoder.decode(ProfileResult.self, from: data) }
//            }
//            completion(response)
//        }
//    }
//}

struct ProfileResult: Codable {
    let username: String
    let first_name: String
    let last_name: String
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = "\(result.first_name)" + " \(result.last_name)"
        self.loginName = "@\(username)"
        self.bio = result.bio
    }
}
