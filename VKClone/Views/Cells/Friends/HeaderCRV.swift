//
//  HeaderCRV.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 2.11.21.
//

import UIKit

class HeaderCRV: UICollectionReusableView {

    static let reuseId = "HeaderCRV"
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .tahoma17()
        textLabel.textColor = .signatures()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    private let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .signatures()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(text: String) {
        textLabel.text = text
    }
}

// MARK: - Setup subviews and constraints
extension HeaderCRV {
    
    private func addSubviewsAndConstraints() {
        addSubview(textLabel)
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            lineView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            lineView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 8),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
