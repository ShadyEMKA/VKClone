//
//  GalleryView.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 17.11.21.
//

import UIKit

class GalleryView: UIView {
    
    private var collectionView: UICollectionView!
    private var photos = [PhotoModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPhoto(photoArray: [PhotoModel]) {
        photos = photoArray
        collectionView.reloadData()
    }
    
    private func configure() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: compositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(PhotoCVC.self, forCellWithReuseIdentifier: PhotoCVC.reuseId)
        collectionView.register(HeaderCRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCRV.reuseId)
        collectionView.backgroundColor = .mainWhite()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        addSubview(collectionView)
    }
}

// MARK: - Create compositional layout
extension GalleryView {
    
    private func compositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (indexSection, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.8), heightDimension: .fractionalHeight(0.8))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5)
            let header = self.createHeader()
            section.boundarySupplementaryItems = [header]
            return section
        }
        return layout
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
}

// MARK: - UICollectionView datasource and delegate
extension GalleryView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.reuseId, for: indexPath) as! PhotoCVC
        cell.configureCell(model: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCRV.reuseId, for: indexPath) as! HeaderCRV
        header.configure(text: "Фотографии")
        return header
    }
}
