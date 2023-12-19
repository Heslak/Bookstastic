//
//  BookDetailViewController.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 18/12/23.
//

import UIKit
import Combine

class BookDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var bookCoverImageView: UIImageView = {
        let bCoverImageView = UIImageView()
        bCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        bCoverImageView.contentMode = .scaleToFill
        bCoverImageView.image = UIImage(named: "placeholder")
        return bCoverImageView
    }()
    
    private lazy var coverView: UIView = {
        let cView = UIView()
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.backgroundColor = .black
        cView.alpha = 0.2
        return cView
    }()
    
    private lazy var detailBookView: DetailBookView = {
        let dBookView = DetailBookView()
        dBookView.translatesAutoresizingMaskIntoConstraints = false
        dBookView.backgroundColor = .white
        dBookView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dBookView.layer.cornerRadius = 16.0
        dBookView.layer.masksToBounds = true
        return dBookView
    }()
    
    // MARK: - Variables
    var viewModel: BookDetailViewModelProtocol
    private var inputViewModel = BookDetailViewModelInput()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    init(viewModel: BookDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        bind()
        inputViewModel.viewDidLoadPublisher.send()
    }
    
    // MARK: - Private Methods
    private func setupController() {
        view.addSubview(bookCoverImageView)
        view.addSubview(coverView)
        view.addSubview(detailBookView)
        view.sendSubviewToBack(bookCoverImageView)
        view.bringSubviewToFront(detailBookView)
        
        bookCoverImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bookCoverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bookCoverImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bookCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        coverView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        coverView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        coverView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        detailBookView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 50.0).isActive = true
        detailBookView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailBookView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailBookView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func bind() {
        
        let output = viewModel.bind(input: inputViewModel)
        
        output.showFetchResultsPublisher.sink { [weak self] in
            self?.fillWithData()
        }.store(in: &cancellable)
        
        output.showFavoriteChangePublisher.sink { [weak self] book in
            self?.detailBookView.changeFavorite(book: book)
        }.store(in: &cancellable)
        
        output.showActivityViewPublisher.sink { [weak self] activityItems in
            self?.shareBook(activityItems: activityItems)
        }.store(in: &cancellable)
    }
    
    private func fillWithData() {
        guard let book = viewModel.book else { return }
        
        detailBookView.configure(book: book,
                                 changeFavoritePublisher: inputViewModel.changeFavoritePublisher,
                                 shareBookPublisher: inputViewModel.shareBookPublisher)
        
        guard let thumbnailUrl = book.volumeInfo.imageLinks?.thumbnail else { return }
        ApiRest.shared.get(from: thumbnailUrl)?.sink { [weak self] result in
            switch result {
            case .finished:
                break
            case .failure(_):
                self?.bookCoverImageView.image =  UIImage(named: "placeholder")
            }
        } receiveValue: { [weak self] data in
            self?.bookCoverImageView.image = UIImage(data: data)
        }.store(in: &cancellable)
    }
    
    private func shareBook(activityItems: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: activityItems,
                                                              applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
}
