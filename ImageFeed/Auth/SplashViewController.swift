//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dosh on 09.01.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauthService = OAuth2Service()
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSplash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage().token {
            UIBlockingProgressHUD.show()
            self.fetchProfile(token: token)
            switchToTabBarController()
        } else {
            switchToAuthViewController()
            //performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func setUpSplash() {
        view.backgroundColor = UIColor(named: "YPBlack")
        let imageView = UIImageView()
        logoImageView = imageView
            
        imageView.image = UIImage(named: "Vector")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
            
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    private func switchToAuthViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController")
        guard let viewController = viewController as? AuthViewController else { return }
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauthService.fetchAuthToken(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                self?.tokenStorage.token = token
                self?.fetchProfile(token: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error.localizedDescription)
                self?.showErrorAlert()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success:
                    if let username = ProfileService.shared.profile?.username {
                        ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
                    } else {
                        print("username is null")
                    }
                    self?.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.showErrorAlert()
                }
            }
        }
        
    }
}

extension SplashViewController {
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
