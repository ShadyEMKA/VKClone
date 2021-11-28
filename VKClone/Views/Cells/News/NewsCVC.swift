//
//  NewsCVC.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 13.11.21.
//

import UIKit

protocol NewsCellViewModel {
    var icon: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var moreTextButton: Bool { get }
    var photoAttacments: PhotoAttachment? { get }
    var likes: String? { get }
    var likesUser: Bool { get }
    var comments: String? { get }
    var reposts: String? { get }
    var views: String? { get }
}

protocol PhotoAttachment {
    var url: String { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
}

protocol MoreTextButtonDelegate: AnyObject {
    func moreTextButtonPressed(for cell: UICollectionViewCell)
}

class NewsCVC: UICollectionViewCell {
    
    static let reuseId = "NewsfeedCVC"
    
    private let topView: UIView = {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    private let iconView: WebImageView = {
        let iconView = WebImageView()
        iconView.backgroundColor = .white
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFill
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .tahoma15()
        nameLabel.textColor = .text()
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    private let dateLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.font = .tahoma13()
        dataLabel.textColor = .signatures()
        dataLabel.numberOfLines = 1
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        return dataLabel
    }()
    private let postTextView: UITextView = {
        let postTextView = UITextView()
        postTextView.font = .tahoma15()
        postTextView.textColor = .text()
        postTextView.isEditable = false
        postTextView.isScrollEnabled = false
        postTextView.dataDetectorTypes = .all
        postTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        postTextView.isHidden = true
        postTextView.translatesAutoresizingMaskIntoConstraints = false
        return postTextView
    }()
    private let moreTextButton: UIButton = {
        let moreTextButton = UIButton(type: .system)
        moreTextButton.setTitle("Показать полностью...", for: .normal)
        moreTextButton.setTitleColor(.systemBlue, for: .normal)
        moreTextButton.titleLabel?.font = .tahoma15()
        moreTextButton.contentVerticalAlignment = .top
        moreTextButton.contentHorizontalAlignment = .left
        moreTextButton.addTarget(self, action: #selector(pressedMoreText), for: .touchUpInside)
        moreTextButton.isHidden = true
        moreTextButton.contentMode = .top
        moreTextButton.translatesAutoresizingMaskIntoConstraints = false
        return moreTextButton
    }()
    private let postImage: WebImageView = {
        let postImage = WebImageView()
        postImage.backgroundColor = .white
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFill
        postImage.translatesAutoresizingMaskIntoConstraints = false
        return postImage
    }()
    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    private let likesView: UIView = {
        let likesView = UIView()
        likesView.backgroundColor = .supportWhite()
        likesView.clipsToBounds = true
        likesView.translatesAutoresizingMaskIntoConstraints = false
        return likesView
    }()
    private let commentsView: UIView = {
        let commentsView = UIView()
        commentsView.backgroundColor = .supportWhite()
        commentsView.clipsToBounds = true
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        return commentsView
    }()
    private let repostsView: UIView = {
        let repostsView = UIView()
        repostsView.backgroundColor = .supportWhite()
        repostsView.clipsToBounds = true
        repostsView.translatesAutoresizingMaskIntoConstraints = false
        return repostsView
    }()
    private let viewsView: UIView = {
        let viewsView = UIView()
        viewsView.translatesAutoresizingMaskIntoConstraints = false
        return viewsView
    }()
    private let likesButton: UIButton = {
        let likesButton = UIButton(type: .system)
        likesButton.setImage(UIImage(named: "like"), for: .normal)
        likesButton.tintColor = .systemGray
        likesButton.translatesAutoresizingMaskIntoConstraints = false
        return likesButton
    }()
    private let commentsButton: UIButton = {
        let commentsButton = UIButton(type: .system)
        commentsButton.setImage(UIImage(named: "comment"), for: .normal)
        commentsButton.tintColor = .systemGray
        commentsButton.translatesAutoresizingMaskIntoConstraints = false
        return commentsButton
    }()
    private let repostsButton: UIButton = {
        let repostsButton = UIButton(type: .system)
        repostsButton.setImage(UIImage(named: "share"), for: .normal)
        repostsButton.tintColor = .systemGray
        repostsButton.translatesAutoresizingMaskIntoConstraints = false
        return repostsButton
    }()
    private let viewsButton: UIButton = {
        let viewsButton = UIButton(type: .system)
        viewsButton.setImage(UIImage(named: "views"), for: .normal)
        viewsButton.tintColor = .systemGray
        viewsButton.translatesAutoresizingMaskIntoConstraints = false
        return viewsButton
    }()
    private let likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.textColor = .blackMuted()
        likesLabel.font = .tahoma15()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        return likesLabel
    }()
    private let commentsLabel: UILabel = {
        let commentsLabel = UILabel()
        commentsLabel.textColor = .blackMuted()
        commentsLabel.font = .tahoma15()
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        return commentsLabel
    }()
    private let repostsLabel: UILabel = {
        let repostsLabel = UILabel()
        repostsLabel.textColor = .blackMuted()
        repostsLabel.font = .tahoma15()
        repostsLabel.translatesAutoresizingMaskIntoConstraints = false
        return repostsLabel
    }()
    private let viewsLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.textColor = .signatures()
        viewsLabel.font = .tahoma15()
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        return viewsLabel
    }()
    private let bottomLineView: UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .mainWhite()
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        return bottomLineView
    }()
    
    private var constraintHeightText: NSLayoutConstraint!
    private var constraintHeightImage: NSLayoutConstraint!
    weak var moreTextButtonDelegate: MoreTextButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        clipsToBounds = true
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        iconView.layer.cornerRadius = iconView.frame.width / 2
        postImage.layer.cornerRadius = 10
        likesView.layer.cornerRadius = 15
        commentsView.layer.cornerRadius = 15
        repostsView.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconView.image = nil
        iconView.task?.cancel()
        nameLabel.text = nil
        dateLabel.text = nil
        postTextView.text = nil
        postImage.image = nil
        postImage.task?.cancel()
        likesLabel.text = nil
        commentsLabel.text = nil
        repostsLabel.text = nil
        viewsLabel.text = nil
        
        postTextView.isHidden = true
        moreTextButton.isHidden = true
        constraintHeightText.isActive = false
        constraintHeightImage.constant = 0
        
        likesButton.tintColor = .systemGray
    }
    
    @objc private func pressedMoreText() {
        moreTextButtonDelegate?.moreTextButtonPressed(for: self)
    }
    
    func configure(model: NewsCellViewModel) {
        self.iconView.set(urlString: model.icon)
        self.nameLabel.text = model.name
        self.dateLabel.text = model.date
        if let text = model.text, !text.isEmpty {
            self.postTextView.isHidden = false
            self.postTextView.text = model.text
            if model.moreTextButton {
                self.constraintHeightText.isActive = true
                self.moreTextButton.isHidden = false
            }
        }
        self.postImage.set(urlString: model.photoAttacments?.url)
        if let const = model.photoAttacments?.height {
            self.constraintHeightImage.constant = const
        }
        self.likesLabel.text = model.likes
        if model.likesUser {
            likesButton.tintColor = .systemRed
        }
        self.commentsLabel.text = model.comments
        self.repostsLabel.text = model.reposts
        self.viewsLabel.text = model.views
    }
}

// MARK: - Setup subviews and constraints
extension NewsCVC {
    
    private func setupSubviews() {
        addSubview(topView)
        addSubview(bottomView)
        addSubview(postTextView)
        addSubview(moreTextButton)
        addSubview(postImage)
        topView.addSubview(iconView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(repostsView)
        bottomView.addSubview(viewsView)
        bottomView.addSubview(bottomLineView)
        likesView.addSubview(likesButton)
        likesView.addSubview(likesLabel)
        commentsView.addSubview(commentsButton)
        commentsView.addSubview(commentsLabel)
        repostsView.addSubview(repostsButton)
        repostsView.addSubview(repostsLabel)
        viewsView.addSubview(viewsButton)
        viewsView.addSubview(viewsLabel)
        
        guard let font = UIFont.tahoma15() else { return }
        constraintHeightText = postTextView.heightAnchor.constraint(equalToConstant: font.lineHeight * CGFloat(3))
        constraintHeightText.isActive = false
        constraintHeightImage = postImage.heightAnchor.constraint(equalToConstant: 0)
        constraintHeightImage.isActive = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            iconView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 2),
            postTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            postTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            moreTextButton.topAnchor.constraint(equalTo: postTextView.bottomAnchor),
            moreTextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14)
        ])

        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: moreTextButton.bottomAnchor),
            postImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            postImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 4),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            bottomLineView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            likesView.heightAnchor.constraint(equalToConstant: 30),
            likesView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            likesButton.centerYAnchor.constraint(equalTo: likesView.centerYAnchor),
            likesButton.leadingAnchor.constraint(equalTo: likesView.leadingAnchor, constant: 15),
            likesButton.heightAnchor.constraint(equalToConstant: 25),
            likesButton.widthAnchor.constraint(equalToConstant: 25),
            likesLabel.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor, constant: 5),
            likesLabel.centerYAnchor.constraint(equalTo: likesView.centerYAnchor),
            likesLabel.trailingAnchor.constraint(equalTo: likesView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor, constant: 10),
            commentsView.heightAnchor.constraint(equalToConstant: 30),
            commentsView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            commentsButton.centerYAnchor.constraint(equalTo: commentsView.centerYAnchor),
            commentsButton.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor, constant: 15),
            commentsButton.heightAnchor.constraint(equalToConstant: 25),
            commentsButton.widthAnchor.constraint(equalToConstant: 25),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 5),
            commentsLabel.centerYAnchor.constraint(equalTo: commentsView.centerYAnchor),
            commentsLabel.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            repostsView.leadingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: 10),
            repostsView.heightAnchor.constraint(equalToConstant: 30),
            repostsView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            repostsButton.centerYAnchor.constraint(equalTo: repostsView.centerYAnchor),
            repostsButton.leadingAnchor.constraint(equalTo: repostsView.leadingAnchor, constant: 15),
            repostsButton.heightAnchor.constraint(equalToConstant: 25),
            repostsButton.widthAnchor.constraint(equalToConstant: 25),
            repostsLabel.leadingAnchor.constraint(equalTo: repostsButton.trailingAnchor, constant: 5),
            repostsLabel.centerYAnchor.constraint(equalTo: repostsView.centerYAnchor),
            repostsLabel.trailingAnchor.constraint(equalTo: repostsView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            viewsView.heightAnchor.constraint(equalToConstant: 30),
            viewsView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            viewsButton.centerYAnchor.constraint(equalTo: viewsView.centerYAnchor),
            viewsButton.leadingAnchor.constraint(equalTo: viewsView.leadingAnchor, constant: 15),
            viewsButton.heightAnchor.constraint(equalToConstant: 25),
            viewsButton.widthAnchor.constraint(equalToConstant: 25),
            viewsLabel.leadingAnchor.constraint(equalTo: viewsButton.trailingAnchor, constant: 5),
            viewsLabel.centerYAnchor.constraint(equalTo: viewsView.centerYAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: viewsView.trailingAnchor, constant: -10)
        ])
    }
}
