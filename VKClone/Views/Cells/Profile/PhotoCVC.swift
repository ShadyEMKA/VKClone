//
//  PhotoCVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 17.11.21.
//

import UIKit

protocol PhotoViewModel {
    var id: Int { get }
    var photoURL: String { get }
}

class PhotoCVC: UICollectionViewCell {
    
    static let reuseId = "PhotoCVC"
    
    private let photoView: WebImageView = {
        let photoView = WebImageView()
        photoView.backgroundColor = .white
        photoView.contentMode = .scaleAspectFill
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.image = nil
        photoView.task?.cancel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.layer.cornerRadius = 8
        photoView.clipsToBounds = true
    }
    
    func configureCell(model: PhotoViewModel) {
        photoView.set(urlString: model.photoURL)
    }
}

extension PhotoCVC {
    
    private func setupSubviewsAndConstraints() {
        addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: topAnchor),
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
