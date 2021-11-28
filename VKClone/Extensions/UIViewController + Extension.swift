//
//  UIViewController + Extension.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 2.11.21.
//

import UIKit

extension UIViewController{
    
    func hideKeyboard() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func hide() {
        view.endEditing(true)
    }
    
    func showAlert(title: String?, message: String?, cancel: Bool = false, completion: @escaping (() -> Void) = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        if cancel {
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(cancelAction)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
