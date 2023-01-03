//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by macOS on 31.12.2022.
//


import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class OAuth2Service {
    static let shared = OAuth2Service()

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?

    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }

    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let path = "/oauth/token"
        + "?client_id=\(AccessKey)"
        + "&&client_secret=\(SecretKey)"
        + "&&redirect_uri=\(RedirectURI)"
        + "&&code=\(code)"
        + "&&grant_type=authorization_code"
        
        let request = makeRequest(code: code, path: path, httpMethod: "POST", baseURL: URL(string: "https://unsplash.com")!)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task                                    
        task.resume()
    }

    private func makeRequest(
        code: String,
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL) -> URLRequest {
            
            var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
            request.httpMethod = httpMethod
            return request
    }

    private struct OAuthTokenResponseBody: Codable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}
