//
//  FavoriteHeaderFooterView.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import UIKit

class FavoriteHeaderFooterView: UITableViewHeaderFooterView {
    
    static let viewName = "FavoriteHeaderFooterView"
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.font = .boldSystemFont(ofSize: 22.0)
        tLabel.text = "Favorites"
        return tLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderFooterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    func setupHeaderFooterView() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
        ])
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
