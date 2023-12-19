//
//  BookInfoView.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import UIKit
import Combine

class BookInfoView: UIView {
    
    // MARK: - UI Components
    private lazy var bookTitleLabel: UILabel = {
        let bTitleLabel = UILabel()
        bTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bTitleLabel.font = .systemFont(ofSize: 22.0)
        bTitleLabel.textColor = .black
        bTitleLabel.numberOfLines = 0
        return bTitleLabel
    }()
    
    private lazy var bookDescriptionLabel: UILabel = {
        let bDescriptionLabel = UILabel()
        bDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bDescriptionLabel.font = .systemFont(ofSize: 15.0)
        bDescriptionLabel.textColor = .lightGray
        bDescriptionLabel.numberOfLines = 0
        return bDescriptionLabel
    }()
    
    private lazy var favoriteButton: UIButton = {
        let fImageView = UIButton()
        fImageView.translatesAutoresizingMaskIntoConstraints = false
        let starImage = UIImage(systemName: "star")
        fImageView.setImage(starImage, for: .normal)
        fImageView.contentMode = .scaleAspectFill
        fImageView.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        return fImageView
    }()
        
    private var indexPath = IndexPath()
    var changeFavoritePublisher = PassthroughSubject<IndexPath, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(bookTitleLabel)
        addSubview(bookDescriptionLabel)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            bookTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor,
                                                      constant: 10.0),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18.0),
            bookDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: favoriteButton.topAnchor,
                                                         constant: -5),

            favoriteButton.heightAnchor.constraint(equalToConstant: 20.0),
            favoriteButton.widthAnchor.constraint(equalToConstant: 20.0),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0),
            favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0)
        ])
    }
    
    func configure(book: Book,
                   changeFavoritePublisher: PassthroughSubject<IndexPath, Never>,
                   indexPath: IndexPath) {
        self.indexPath = indexPath
        self.changeFavoritePublisher = changeFavoritePublisher
        
        bookTitleLabel.text = book.volumeInfo.title
        bookDescriptionLabel.text = book.volumeInfo.getAuthors()
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
        changeFavoritePublisher.send(indexPath)
    }
}
