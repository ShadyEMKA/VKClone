//
//  WebImageView.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 17.11.21.
//

import UIKit

class WebImageView: UIImageView {
    
    private let cache = NSCache<NSString,NSData>()
    var task: URLSessionTask?
    
    func set(urlString: String?) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
                  self.image = nil
                  return }
        
        if let cachedResponse = cache.object(forKey: NSString(string: urlString)) {
            self.image = UIImage(data: cachedResponse as Data)
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data else { return }
            DispatchQueue.main.async {
                self.cache.setObject(data as NSData, forKey: urlString as NSString)
                self.image = UIImage(data: data)
            }
        }
        task?.resume()
    }
}
