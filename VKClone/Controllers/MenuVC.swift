//
//  MenuVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit

class MenuVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        let configImage = UIImage.SymbolConfiguration(weight: .bold)
        viewControllers = [createNavigationController(for: ProfileVC(), title: "Профиль", image: UIImage(systemName: "person", withConfiguration: configImage)!),
                           createNavigationController(for: FriendsVC(), title: "Друзья", image: UIImage(systemName: "person.2", withConfiguration: configImage)!),
                           createNavigationController(for: NewsfeedVC(), title: "Новости", image: UIImage(systemName: "newspaper", withConfiguration: configImage)!)]
        tabBar.tintColor = .tabBarItem()
        tabBar.unselectedItemTintColor = .tabBarUnselectedItem()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func createNavigationController(for vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let nc = UINavigationController(rootViewController: vc)
        nc.title = title
        nc.tabBarItem.image = image
        vc.title = title
        
        guard let font = UIFont.tahomaBold17() else { fatalError("Error font") }

        let ncAppearance = UINavigationBarAppearance()
        ncAppearance.configureWithOpaqueBackground()
        ncAppearance.titleTextAttributes = [NSAttributedString.Key.font: font]
        ncAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        ncAppearance.backgroundColor = .headerAndButton()
        nc.navigationBar.standardAppearance = ncAppearance
        nc.navigationBar.scrollEdgeAppearance = ncAppearance
        nc.navigationBar.tintColor = .white
        return nc
    }
}
