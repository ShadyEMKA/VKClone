//
//  FriendPhotosVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 16.11.21.
//

import UIKit

class FriendPhotosVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private var photos = [PhotoModel]()
    private var currentId: Int

    override func viewDidLoad() {
        super.viewDidLoad()

        let sortButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .done, target: self, action: #selector(reversePhoto))
        navigationItem.rightBarButtonItem = sortButtonItem
        navigationItem.title = "Фотографии"
        setupCollectionView()
        loadingPhotos() 
    }
    
    init(currentId: Int) {
        self.currentId = currentId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func reversePhoto() {
        self.photos = photos.reversed()
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        collectionView.register(PhotoCVC.self, forCellWithReuseIdentifier: PhotoCVC.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
}

// MARK: - Create compositional layout
extension FriendPhotosVC {
    
    private func createCompositionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.layoutForGallery()
            return section
        }
        return layout
    }
    
    private func layoutForGallery() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        section.interGroupSpacing = 5
        return section
    }
}

//MARK: - UICollectionDataSource and UICollectionDelegate
extension FriendPhotosVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.reuseId, for: indexPath) as! PhotoCVC
        cell.configureCell(model: photos[indexPath.row])
        return cell
    }
}

// MARL: - Loading photos from internet
extension FriendPhotosVC {
    
    private func loadingPhotos() {
        NetworkDataFetcher.shared.getPhotos(for: currentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.photos = model.response.items.map { PhotoModel(id: $0.id, photoURL: $0.url) }
                self.collectionView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}
