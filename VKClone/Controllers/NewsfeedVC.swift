//
//  NewsfeedVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 13.11.21.
//

import UIKit

class NewsfeedVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private var news = [NewsModel]()
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshSwipe), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        loadingFromNetwork()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(NewsCVC.self, forCellWithReuseIdentifier: NewsCVC.reuseId)
        collectionView.backgroundColor = .mainWhite()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        view.addSubview(collectionView)
    }
    
    @objc private func refreshSwipe() {
        loadingFromNetwork()
    }
}

// MARK: - Create compositional layout
extension NewsfeedVC {
    
    private func createCompositionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.layoutForNeewsfeed()
            return section
        }
        return layout
    }
    
    private func layoutForNeewsfeed() -> NSCollectionLayoutSection {
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000))
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 20

        return section
    }
}

// MARK: - UICollectionView datasource and delegate
extension NewsfeedVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCVC.reuseId, for: indexPath) as! NewsCVC
        cell.configure(model: news[indexPath.row])
        cell.moreTextButtonDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - Loading data from network and configure view model
extension NewsfeedVC {
    
    private func loadingFromNetwork() {
        NetworkDataFetcher.shared.getNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.news = self.configureViewModel(news: news)
                self.collectionView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configureViewModel(news: NewsResponseWrapped) -> [NewsModel] {
        let queue = DispatchQueue(label: "Loading news", qos: .userInitiated)
        var newsViewModel = [NewsModel]()
        news.response.items.forEach { item in
            queue.async(flags: .barrier) {
                guard let user = self.nameProfileOrGroup(sourceId: item.sourceId,
                                                         profiles: news.response.profiles,
                                                         groups: news.response.groups) else { fatalError("Error user configure") }
                newsViewModel.append(NewsModel(postId: item.postId,
                                               icon: user.avatar,
                                               name: user.name,
                                               date: item.date.dateFormat(),
                                               text: item.text,
                                               moreTextButton: self.configureMoreTextButton(text: item.text),
                                               photoAttacments: self.configurePhotoAttachment(value: item.attachments),
                                               likes: item.likes?.count.reviewCountForNews(),
                                               likesUser: self.isLike(value: item.likes?.userLikes),
                                               comments: item.comments?.count.reviewCountForNews(),
                                               reposts: item.reposts?.count.reviewCountForNews(),
                                               views: item.views?.count.reviewCountForNews()))
            }
        }
        return queue.sync {
            newsViewModel
        }
    }
    
    private func nameProfileOrGroup(sourceId: Int, profiles: [Profile], groups: [Group]) -> UserViewModel? {
        if sourceId > 0 {
            let user = profiles.first(where: { profile in
                sourceId == profile.id
            })
            return user
        } else if sourceId < 0 {
            let user = groups.first(where: { group in
                abs(sourceId) == group.id
            })
            return user
        }
        return nil
    }
    
    private func configureMoreTextButton(text: String?) -> Bool {
        guard let text = text else { return false }
        let height = text.height(width: UIScreen.main.bounds.width - 40, font: .tahoma15())
        
        guard let font = UIFont.tahoma15() else { return false }
        let heightLimit = font.lineHeight * CGFloat(6)
        if height > heightLimit {
            return true
        }
        return false
    }
    
    private func isLike(value: Int?) -> Bool {
        if value == 0 {
            return false
        } else if value == 1 {
            return true
        }
        return false
    }
    
    private func configurePhotoAttachment(value: [Attachment]?) -> NewsPhotoAttachment? {
        guard let photo = value?.first?.photo else { return nil }
        let ratio = Float(photo.height) / Float(photo.width)
        let newWidth = CGFloat(UIScreen.main.bounds.width - 40)
        let newHeight = CGFloat(Float(newWidth) * ratio)
        let item = NewsPhotoAttachment(url: photo.url, width: newWidth, height: newHeight)
        return item
    }
}

//MARK: - MoreTextButton delegate
extension NewsfeedVC: MoreTextButtonDelegate {
    
    func moreTextButtonPressed(for cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        news[indexPath.row].moreTextButton = false
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
