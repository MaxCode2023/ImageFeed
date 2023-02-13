//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by macOS on 01.01.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let tabBarViewControllerIdentifier = "TabBarViewController"

    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared

    private let logoImage = UIImageView()
    
    override func viewDidLoad() {
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if oauth2Service.authToken != nil {
            self.fetchProfile()
            UIBlockingProgressHUD.show()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        logoImage.image = UIImage(named: "Logo")
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tabBarViewControllerIdentifier)
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchProfile()
            case .failure:
                self.showAlert()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                ProfileImageService.shared.fetchProfileImageURL(username: self.profileService.profile?.username ?? "") { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
}
