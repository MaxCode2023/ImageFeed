//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by macOS on 30.12.2022.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
