//
//  DetailBookView.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import UIKit
import Combine

class DetailBookView: UIView {
    
    // MARK: - UI Components
    private lazy var bookTitleLabel: UILabel = {
        let bTitleLabel = UILabel()
        bTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bTitleLabel.font = .systemFont(ofSize: 22.0)
        bTitleLabel.textColor = .black
        bTitleLabel.numberOfLines = 0
        return bTitleLabel
    }()
    
    private lazy var bookAuthorsLabel: UILabel = {
        let bTitleLabel = UILabel()
        bTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bTitleLabel.font = .systemFont(ofSize: 15.0)
        bTitleLabel.textColor = .black
        bTitleLabel.numberOfLines = 0
        return bTitleLabel
    }()
    
    private lazy var bookDescriptionLabel: UILabel = {
        let bDescriptionLabel = UILabel()
        bDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bDescriptionLabel.font = .systemFont(ofSize: 15.0)
        bDescriptionLabel.textColor = .systemGray
        bDescriptionLabel.numberOfLines = 0
        return bDescriptionLabel
    }()
    
    private lazy var favoriteButton: UIButton = {
        let fButton = UIButton()
        fButton.translatesAutoresizingMaskIntoConstraints = false
        let starImage = UIImage(systemName: "star")
        fButton.setImage(starImage, for: .normal)
        fButton.contentMode = .scaleAspectFill
        fButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        return fButton
    }()
    
    private lazy var shareButton: UIButton = {
        let sButton = UIButton()
        sButton.translatesAutoresizingMaskIntoConstraints = false
        let shareImage = UIImage(systemName: "square.and.arrow.up")
        sButton.setImage(shareImage, for: .normal)
        sButton.contentVerticalAlignment = .fill
        sButton.contentHorizontalAlignment = .fill
        sButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        return sButton
    }()
    
    // MARK: - Variables
    var changeFavoritePublisher = PassthroughSubject<Void, Never>()
    var shareBookPublisher = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(bookTitleLabel)
        addSubview(favoriteButton)
        addSubview(bookAuthorsLabel)
        addSubview(bookDescriptionLabel)
        addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            bookTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookTitleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor,
                                                     constant: -15.0),
            bookTitleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: favoriteButton.bottomAnchor),

            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            favoriteButton.heightAnchor.constraint(equalToConstant: 20.0),
            favoriteButton.widthAnchor.constraint(equalToConstant: 20.0),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0),
            
            
            
            bookAuthorsLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor,
                                                      constant: 10.0),
            bookAuthorsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookAuthorsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookAuthorsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18.0),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: bookAuthorsLabel.bottomAnchor,
                                                      constant: 10.0),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18.0),
            bookDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: shareButton.topAnchor,
                                                         constant: -15),
            
            shareButton.heightAnchor.constraint(equalToConstant: 30.0),
            shareButton.widthAnchor.constraint(equalToConstant: 25.0),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15.0)
        ])
    }
    
    func configure(book: Book,
                   changeFavoritePublisher: PassthroughSubject<Void, Never>,
                   shareBookPublisher: PassthroughSubject<Void, Never>) {
        self.changeFavoritePublisher = changeFavoritePublisher
        self.shareBookPublisher = shareBookPublisher
        
        bookTitleLabel.text = book.volumeInfo.title
        bookDescriptionLabel.text = book.volumeInfo.description ?? "No info"
        bookAuthorsLabel.text = book.volumeInfo.getAuthors()
        
        let favoriteImage = UIImage(systemName: book.isFavorite ? "star.fill" : "star")
        favoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    func changeFavorite(book: Book) {
        let favoriteImage = UIImage(systemName: book.isFavorite ? "star.fill" : "star")
        
        UIView.transition(with: favoriteButton,
                          duration: 0.3,
                          options: .transitionFlipFromLeft ,
                          animations: {
            self.favoriteButton.setImage(favoriteImage, for: .normal)
        })
    }
    
    // MARK: - Private Methods
    @objc private func favoriteButtonPressed() {
        changeFavoritePublisher.send()
    }
    
    @objc private func shareButtonPressed() {
        shareBookPublisher.send()
    }
    
}
