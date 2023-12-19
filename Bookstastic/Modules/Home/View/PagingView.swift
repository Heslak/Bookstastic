//
//  PagingView.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import UIKit
import Combine

class PagingView: UIView {
    
    // MARK: - UI Components
    private lazy var horizontalStackView: UIStackView = {
        let hStackView = UIStackView()
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        return hStackView
    }()
    
    private lazy var previousButton: UIButton = {
        let pButton = UIButton()
        pButton.setTitle("Previous", for: .normal)
        pButton.setTitleColor(.systemBlue, for: .normal)
        pButton.setTitleColor(.systemGray4, for: .highlighted)
        pButton.setTitleColor(.systemGray4, for: .disabled)
        pButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        return pButton
    }()
    
    private lazy var nextButton: UIButton = {
        let nButton = UIButton()
        nButton.setTitle("Next", for: .normal)
        nButton.setTitleColor(.systemBlue, for: .normal)
        nButton.setTitleColor(.systemGray4, for: .highlighted)
        nButton.setTitleColor(.systemGray4, for: .disabled)
        nButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return nButton
    }()
    
    private lazy var counterLabel: UILabel = {
        let cLabel = UILabel()
        cLabel.translatesAutoresizingMaskIntoConstraints = false
        cLabel.font = .systemFont(ofSize: 16.0)
        cLabel.text = "Page 1"
        cLabel.textAlignment = .center
        return cLabel
    }()
    
    var increaseCounterPublisher = PassthroughSubject<Void, Never>()
    var decreaseCounterPublisher = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    @objc private func setupView() {
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(previousButton)
        horizontalStackView.addArrangedSubview(counterLabel)
        horizontalStackView.addArrangedSubview(nextButton)
        
        backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            horizontalStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func updateCounter(current: Int, totalItems: Int) {
        previousButton.isEnabled = current > 1
        nextButton.isEnabled = totalItems > 1
        counterLabel.text = "Page \(current)"
    }
    
    // MARK: - Private Methods
    @objc private func nextButtonPressed() {
        increaseCounterPublisher.send()
    }
    
    @objc private func previousButtonPressed() {
        decreaseCounterPublisher.send()
    }
}
