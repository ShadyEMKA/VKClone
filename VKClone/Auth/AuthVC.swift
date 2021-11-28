//
//  AuthVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit
import WebKit

class AuthVC: UIViewController {
    
    private let webView = WKWebView()
    private let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        addSubviewsAndConstraints()
        loadWebView()
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadWebView() {
        guard let url = createURLForAutorize() else { return }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    private func createURLForAutorize() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: "7989356"),
                                    URLQueryItem(name: "display", value: "mobile"),
                                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                    URLQueryItem(name: "scope", value: "wall,friends"),
                                    URLQueryItem(name: "response_type", value: "token"),
                                    URLQueryItem(name: "v", value: "5.131")]
        return urlComponents.url
    }
    
    private func showMenu() {
        guard userDefaults.string(forKey: "token") != nil else {
            loadWebView()
            return
        }
        let newVC = MenuVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.modalTransitionStyle = .coverVertical
        guard let sceneDelegate = (UIApplication.shared.connectedScenes.first?.delegate) as? SceneDelegate else { return }
        sceneDelegate.window?.rootViewController = newVC
    }
}

// MARK: - Get token and userId

extension AuthVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
                  url.path == "/blank.html",
                  let fragment = url.fragment else {
                      decisionHandler(.allow)
                      return }
        
        let params = fragment.components(separatedBy: "&").map { $0.components(separatedBy: "=") }.reduce([String: String]()) { result, param in
            var dict = result
            let key = param[0]
            let value = param[1]
            dict[key] = value
            return dict
        }
        
        guard let token = params["access_token"],
              let userId = params["user_id"] else { return }
        
        userDefaults.set(token, forKey: "token")
        userDefaults.set(userId, forKey: "userId")
        userDefaults.set(Date(), forKey: "tokenDate")
        
        decisionHandler(.cancel)
        webView.stopLoading()
        showMenu()
    }
}

