//
//  FriendsVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit
import CoreData

class FriendsVC: UIViewController {
    
    enum Sections: Int {
        case recommend
        case all
        
        func description(count: Int) -> String {
            switch self {
            case .recommend:
                return "Рекомендации"
            case .all:
                return "Друзья - \(count)"
            }
        }
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Sections, NSManagedObjectID>?
    
    private let coreDataStack = CoreDataStack(modelName: "VKClone")
    
    private var friends = [Friend]()
    private var recommendFriends = [Friend]()
    
    lazy private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTarget), for: .valueChanged)
        return refresh
    }()
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск..."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.tintColor = .systemGray
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDiffableDataSource()
        setupSearchController()
        loadFromBD()
        loadFromNetwork()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(FriendCVC.self, forCellWithReuseIdentifier: FriendCVC.reuseId)
        collectionView.register(RecomendFriendCVC.self, forCellWithReuseIdentifier: RecomendFriendCVC.reuseId)
        collectionView.register(HeaderCRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCRV.reuseId)
        collectionView.backgroundColor = .mainWhite()
        collectionView.contentInset.top = 10
        collectionView.delegate = self
        collectionView.addSubview(refreshControl)
        view.addSubview(collectionView)
    }
    
    @objc private func refreshTarget() {
        loadFromNetwork()
    }
}

// MARK: - Compositional layout
extension FriendsVC {
    
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = Sections(rawValue: sectionIndex) else { fatalError() }
            switch section {
            case .recommend:
                return self.setupLayoutOnline()
            case .all:
                return self.setupLayoutAll()
            }
        }
        return layout
    }
    
    private func setupLayoutOnline() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(60), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let header = layoutHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func setupLayoutAll() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let header = layoutHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func layoutHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
}

// MARK: - Setup search controller
extension FriendsVC: UISearchBarDelegate {
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadData(searchText: nil)
    }
}

// MARK: - Diffable datasource
extension FriendsVC {
    
    func setupDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) in
            guard let section = Sections(rawValue: indexPath.section) else { fatalError() }
            switch section {
            case .recommend:
                let item = self.coreDataStack.contextManager.object(with: itemIdentifier) as! Friend
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendFriendCVC.reuseId, for: indexPath) as! RecomendFriendCVC
                cell.configureCell(model: item)
                return cell
            case .all:
                let item = self.coreDataStack.contextManager.object(with: itemIdentifier) as! Friend
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCVC.reuseId, for: indexPath) as! FriendCVC
                cell.configureCell(model: item)
                return cell
            }
        })
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let self = self else { fatalError("Error header") }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCRV.reuseId, for: indexPath) as! HeaderCRV
            guard let section = Sections(rawValue: indexPath.section) else { fatalError("Error header") }
            header.configure(text: section.description(count: self.friends.count))
            return header
        }
    }
    
    private func reloadData(searchText: String?) {
        let filtred = friends.filter { friend in
            friend.contains(searchText: searchText)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Sections,NSManagedObjectID>()
        snapshot.appendSections([.recommend, .all])
        let friendsID = filtred.map { $0.objectID }
        let recomendFriendsID = recommendFriends.map { $0.objectID }
        snapshot.appendItems(recomendFriendsID, toSection: .recommend)
        snapshot.appendItems(friendsID, toSection: .all)
        dataSource?.apply(snapshot)
        refreshControl.endRefreshing()
    }
}

// MARK: - Loading friends from CoreData
extension FriendsVC {
    
    private func loadFromBD() {
        let requestFriends = Friend.fetchRequest()
        requestFriends.predicate = NSPredicate(format: "recommend == false")
        let sortName = NSSortDescriptor(key: #keyPath(Friend.name), ascending: true)
        requestFriends.sortDescriptors = [sortName]
        do {
            friends = try coreDataStack.contextManager.fetch(requestFriends)
        } catch let error as NSError {
            showAlert(title: "Ошибка", message: error.userInfo.description)
        }
        let requestRecommend = Friend.fetchRequest()
        requestRecommend.predicate = NSPredicate(format: "recommend == true")
        do {
            recommendFriends = try coreDataStack.contextManager.fetch(requestRecommend)
        } catch let error as NSError {
            showAlert(title: "Ошибка", message: error.userInfo.description)
        }
        reloadData(searchText: nil)
    }
}

// MARK: - Loading friends from network
extension FriendsVC {
    
    private func loadFromNetwork() {
        NetworkDataFetcher.shared.getFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.friends = model.response.items.map { friend in
                    let request = Friend.fetchRequest()
                    request.predicate = NSPredicate(format: "idProfile == \(friend.id)")
                    if let item = try? self.coreDataStack.contextManager.fetch(request).first {
                        if item.online != friend.onlineBool {
                            item.online.toggle()
                        }
                        return item
                    }
                    let item = Friend(context: self.coreDataStack.contextManager)
                    item.name = friend.fullName
                    item.mainPhoto = friend.photo100
                    item.online = friend.onlineBool
                    item.idProfile = friend.id
                    item.recommend = false
                    return item
                }
                self.coreDataStack.saveContext()
                self.loadFromBD()
            case .failure(let error as NSError):
                self.showAlert(title: "Ошибка", message: error.userInfo.description)
            }
        }
        
        NetworkDataFetcher.shared.getRecomendFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                if !self.recommendFriends.isEmpty {
                    let recommendID = self.recommendFriends.map { $0.objectID }
                    let request = NSBatchDeleteRequest(objectIDs: recommendID)
                    do {
                        try self.coreDataStack.contextManager.execute(request)
                    } catch let error as NSError {
                        print("Error delete recommend friends: \(error), description: \(error.userInfo)")
                    }
                }
                self.recommendFriends = model.response.items.map { friend in
                    let item = Friend(context: self.coreDataStack.contextManager)
                    item.name = friend.fullName
                    item.mainPhoto = friend.photo100
                    item.online = friend.onlineBool
                    item.idProfile = friend.id
                    item.recommend = true
                    return item
                }
                self.coreDataStack.saveContext()
                self.loadFromBD()
            case .failure(let error as NSError):
                self.showAlert(title: "Ошибка", message: error.userInfo.description)
            }
        }
    }
}

// MARK: - UICollectionView delegate
extension FriendsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section) else { return }
        switch section {
        case .recommend:
            showAlert(title: "Рекомендации", message: nil)
        case .all:
            guard let id = dataSource?.itemIdentifier(for: indexPath) else { return }
            let item = coreDataStack.contextManager.object(with: id) as! Friend
            let newVC = FriendPhotosVC(currentId: item.idProfile)
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
}

