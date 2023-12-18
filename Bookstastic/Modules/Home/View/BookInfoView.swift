//
//  BookInfoView.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import UIKit

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
    
    private lazy var favoriteImageView: UIImageView = {
        let fImageView = UIImageView()
        fImageView.translatesAutoresizingMaskIntoConstraints = false
        fImageView.image = UIImage(systemName: "star")
        fImageView.contentMode = .scaleAspectFill
        return fImageView
    }()
        
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
        addSubview(favoriteImageView)
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            bookTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor,
                                                      constant: 10.0),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18.0),
            bookDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: favoriteImageView.topAnchor,
                                                         constant: -5),

            favoriteImageView.heightAnchor.constraint(equalToConstant: 20.0),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 20.0),
            favoriteImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0),
            favoriteImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0)
        ])
    }
    
    func configure(book: Book) {
        bookTitleLabel.text = book.volumeInfo.title
        bookDescriptionLabel.text = book.volumeInfo.getAuthors()
        
        let favoriteImage = UIImage(systemName: book.isFavorite ? "star.fill" : "star")
        favoriteImageView.image = favoriteImage
    }
    
    func changeFavorite(book: Book) {
        let favoriteImage = UIImage(systemName: book.isFavorite ? "star.fill" : "star")
        
        UIView.transition(with: favoriteImageView,
                          duration: 0.3,
                          options: .transitionFlipFromLeft ,
                          animations: {
            self.favoriteImageView.image = favoriteImage
        })
    }
}
