//
//  ProfileVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit
import CoreData

protocol UserViewModel {
    var id: Int { get }
    var name: String { get }
    var avatar: String { get }
}

class ProfileVC: UIViewController {
    
    private var coreDataStack = CoreDataStack(modelName: "VKClone")
    
    private let avatarView: WebImageView = {
        let avatarView = WebImageView()
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        return avatarView
    }()
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .tahomaBold20()
        nameLabel.textColor = .blackMuted()
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    private let galleryView: GalleryView = {
        let galleryView = GalleryView()
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        return galleryView
    }()
    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .headerAndButton()
        
        configure()
        setupSubviews()
        setupConstraints()
        loadingUserFromBD()
        loadingUserFromNetwork()
        loadGalleryUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
    }
    
    private func configure() {
        view.backgroundColor = .mainWhite()
        
        let logoutButtonItem = UIBarButtonItem(image: UIImage(systemName: "iphone.and.arrow.forward"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButtonItem
    }
    
    @objc private func logout() {
        showAlert(title: "Выйти из приложения", message: "Вы уверены?", cancel: true) {
            UserDefaults.standard.removeObject(forKey: "token")
            exit(0)
        }
    }
}

// MARK: - Setup subviews and constraints
extension ProfileVC {
    
    private func setupSubviews() {
        view.addSubview(avatarView)
        view.addSubview(nameLabel)
        view.addSubview(galleryView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            avatarView.widthAnchor.constraint(equalToConstant: 180),
            avatarView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50),
            galleryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
}

// MARK: - Loading user from CoreData
extension ProfileVC {
    
    private func loadingUserFromBD() {
        do {
            user = try coreDataStack.contextManager.fetch(User.fetchRequest()).first
            avatarView.set(urlString: user?.avatar)
            nameLabel.text = user?.name
        } catch let error as NSError {
            showAlert(title: "Ошибка", message: "\(error.userInfo)")
        }
    }
}

// MARK: - Loading user from network
extension ProfileVC {
    
    private func loadingUserFromNetwork() {
        NetworkDataFetcher.shared.getUser(for: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let userModel = model.response?.first else { return }
                let request = User.fetchRequest()
                request.predicate = NSPredicate(format: "idProfile == \(userModel.id)")
                if let item = try? self.coreDataStack.contextManager.fetch(request).first {
                    if item.idProfile == userModel.id {
                        self.user = item
                        return
                    }
                }
                let user = User(context: self.coreDataStack.contextManager)
                user.name = userModel.fullName
                user.avatar = userModel.photo200
                user.idProfile = userModel.id
                self.coreDataStack.saveContext()
                self.loadingUserFromBD()
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    private func loadGalleryUser() {
        NetworkDataFetcher.shared.getPhotos(for: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                let photoModel = model.response.items.map { PhotoModel(id: $0.id, photoURL: $0.url) }
                self.galleryView.loadPhoto(photoArray: photoModel)
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}
