//
//  RecomendFriendCVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit

class RecomendFriendCVC: UICollectionViewCell {
    
    static let reuseId = "RecomendFriendCVC"
    
    private let photoView: WebImageView = {
        let photoView = WebImageView()
        photoView.backgroundColor = .white
        photoView.clipsToBounds = true
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()
    private let onlineSymbol: UIImageView = {
        let onlineSymbol = UIImageView()
        onlineSymbol.image = UIImage(systemName: "circle.fill")
        onlineSymbol.tintColor = .systemGreen
        onlineSymbol.isHidden = true
        onlineSymbol.translatesAutoresizingMaskIntoConstraints = false
        return onlineSymbol
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.image = nil
        photoView.task?.cancel()
        onlineSymbol.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.layer.cornerRadius = photoView.frame.width / 2
    }
    
    func configureCell(model: FriendViewModel) {
        photoView.set(urlString: model.mainPhoto)
        if model.online {
            onlineSymbol.isHidden = false
        }
    }
}

// MARK: - Setup subviews and constraints
extension RecomendFriendCVC {
    
    private func setupSubviews() {
        addSubview(photoView)
        addSubview(onlineSymbol)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: topAnchor),
            photoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            onlineSymbol.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            onlineSymbol.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            onlineSymbol.heightAnchor.constraint(equalToConstant: 16),
            onlineSymbol.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
}
