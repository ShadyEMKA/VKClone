//
//  FriendCVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit

protocol FriendViewModel {
    var name: String { get }
    var online: Bool { get }
    var mainPhoto: String { get }
    var idProfile: Int { get }
}

class FriendCVC: UICollectionViewCell {
    
    static let reuseId = "FriendCVC"
    
    private let photoView: WebImageView = {
        let photoView = WebImageView()
        photoView.backgroundColor = .white
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .tahoma15()
        nameLabel.textColor = .text()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    private let onlineLabel: UILabel = {
        let onlineLabel = UILabel()
        onlineLabel.font = .tahoma13()
        onlineLabel.textColor = .signatures()
        onlineLabel.translatesAutoresizingMaskIntoConstraints = false
        return onlineLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.layer.cornerRadius = photoView.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.image = nil
        photoView.task?.cancel()
        nameLabel.text = nil
        onlineLabel.text = nil
    }
    
    func configureCell(model: FriendViewModel) {
        photoView.set(urlString: model.mainPhoto)
        nameLabel.text = model.name
        if model.online {
            onlineLabel.text = "Online"
        }
    }
}

// MARK: - Setup subviews and constraints
extension FriendCVC {
    
    private func setupSubviews() {
        addSubview(photoView)
        addSubview(nameLabel)
        addSubview(onlineLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            photoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoView.widthAnchor.constraint(equalToConstant: 60),
            photoView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            onlineLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            onlineLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 20),
            onlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
