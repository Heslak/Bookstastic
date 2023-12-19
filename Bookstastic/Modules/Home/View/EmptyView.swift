//
//  EmptyView.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 19/12/23.
//

import UIKit

class EmptyView: UIView {
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.font = .boldSystemFont(ofSize: 16.0)
        tLabel.textColor = .systemGray2
        tLabel.textAlignment = .center
        tLabel.numberOfLines = 0
        return tLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        
        let topAnchor = titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                                        constant: 16.0)
        topAnchor.priority = UILayoutPriority(rawValue: 999.0)
        
        let leadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0)
        leadingAnchor.priority = UILayoutPriority(rawValue: 999.0)
        
        let centerAnchor = titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerAnchor.priority = UILayoutPriority(rawValue: 999.0)
        
        let bottomAnchor = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                              constant: -16.0)
        bottomAnchor.priority = UILayoutPriority(rawValue: 999.0)
        
        
        NSLayoutConstraint.activate([
            topAnchor,
            leadingAnchor,
            centerAnchor,
            bottomAnchor
        ])
    }
    
    func configure(message: String) {
        titleLabel.text = message
    }
}
