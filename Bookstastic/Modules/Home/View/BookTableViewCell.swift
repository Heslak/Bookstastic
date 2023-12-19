//
//  BookTableViewCell.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import UIKit
import Combine

class BookTableViewCell: UITableViewCell {
    
    static let cellName = "BookTableViewCell"
    
    // MARK: - UI Components
    private lazy var bookImageView: UIImageView = {
        let bImageView = UIImageView()
        bImageView.translatesAutoresizingMaskIntoConstraints = false
        bImageView.layer.cornerRadius = 16.0
        bImageView.layer.masksToBounds = true
        bImageView.contentMode = .scaleAspectFill
        bImageView.image = UIImage(named: "placeholder")
        return bImageView
    }()
    
    private lazy var conteinerView: UIView = {
        let iView = UIView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.layer.cornerRadius = 16.0
        iView.layer.masksToBounds = true
        iView.backgroundColor = .white
        return iView
    }()
    
    private lazy var bookInfoView: BookInfoView = {
        let bInfoView = BookInfoView()
        bInfoView.translatesAutoresizingMaskIntoConstraints = false
        return bInfoView
    }()
    
    private var subscribers = Set<AnyCancellable>()
    private var currentUrl: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(conteinerView)
        contentView.addSubview(bookInfoView)
        contentView.bringSubviewToFront(bookImageView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 15.0),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 15.0),
            bookImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -15.0),
            bookImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                 multiplier: 0.35),
                
            conteinerView.topAnchor.constraint(equalTo: bookImageView.topAnchor,
                                           constant: 30.0),
            conteinerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            conteinerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            conteinerView.bottomAnchor.constraint(equalTo: bookImageView.bottomAnchor),
        
            bookInfoView.topAnchor.constraint(equalTo: conteinerView.topAnchor),
            bookInfoView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor),
            bookInfoView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            bookInfoView.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image =  UIImage(named: "placeholder")
        currentUrl = ""
    }
    
    func configure(book: Book,
                   changeFavoritePublisher: PassthroughSubject<IndexPath, Never>,
                   indexPath: IndexPath) {
        bookInfoView.configure(book: book,
                               changeFavoritePublisher: changeFavoritePublisher,
                               indexPath: indexPath)
        guard let currentUrl = book.volumeInfo.imageLinks?.smallThumbnail else { return }
        self.currentUrl = currentUrl
        
        ApiRest.shared.get(from: currentUrl)?.sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] data in
            if self?.currentUrl == currentUrl {
                self?.bookImageView.image = UIImage(data: data)
            }
        }).store(in: &subscribers)
    }
    
    func changeFavorite(book: Book) {
        bookInfoView.changeFavorite(book: book)
    }
}
