//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dosh on 17.12.2023.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    private var logoutButton: UIButton!
    private var descriptionLabel: UILabel = UILabel()
    private var tagLabel: UILabel = UILabel()
    private var nameLabel: UILabel = UILabel()
    private var avatarImage: UIImageView = UIImageView()
   
    private var mainFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    private var headerFont = UIFont.systemFont(ofSize: 23, weight: .bold)
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAvatar()
        initName()
        initTag()
        initDescription()
        initLogout()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    @objc
    func clickLogoutButton(_ sender: Any) {
    }
    
    private func updateAvatar() {
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url  = URL(string: profileImageUrl)
        else { return }
        avatarImage.kf.setImage(with: url, placeholder: UIImage(named: "profile_photo"), options: [])
    }
    
    func initAvatar() {
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarImage)
        
        avatarImage.image = UIImage(named: "profile_photo")
        
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            
        ])
        avatarImage.layer.cornerRadius = 35
        avatarImage.clipsToBounds = true
    }
    
    func initName() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        nameLabel.text = profileService.profile?.name
        nameLabel.font = headerFont
        nameLabel.textColor = .ypWhite
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor)
        ])
    }
    
    func initTag() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tagLabel)
        
        tagLabel.text = profileService.profile?.username
        tagLabel.font = mainFont
        tagLabel.textColor = .ypGray
        
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            tagLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor)
        ])
    }
    
    func initDescription() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.text = profileService.profile?.bio
        descriptionLabel.font = mainFont
        descriptionLabel.textColor = .ypWhite
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor)
        ])
    }
    
    func initLogout() {
        let exitImage = UIImage(named: "Exit")?.withRenderingMode(.alwaysOriginal)
        logoutButton = UIButton.systemButton(
            with: exitImage!,
            target: self,
            action: #selector(Self.clickLogoutButton)
        )
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor)
        ])
    }
    
}
