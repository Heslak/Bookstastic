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
    
    private lazy var bookAuthorsLabel: UILabel = {
        let bAuthorsLabel = UILabel()
        bAuthorsLabel.translatesAutoresizingMaskIntoConstraints = false
        bAuthorsLabel.font = .systemFont(ofSize: 15.0)
        bAuthorsLabel.textColor = .lightGray
        bAuthorsLabel.numberOfLines = 0
        return bAuthorsLabel
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
        addSubview(bookAuthorsLabel)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            bookTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bookAuthorsLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor,
                                                      constant: 10.0),
            bookAuthorsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            bookAuthorsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookAuthorsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18.0),
            bookAuthorsLabel.bottomAnchor.constraint(lessThanOrEqualTo: favoriteButton.topAnchor,
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
        changeFavoritePublisher.send(indexPath)
    }
}
