//
//  HomeBooksViewController.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import UIKit
import Combine

class HomeBooksViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var booksTableView: UITableView = {
        let bTableView = UITableView()
        bTableView.translatesAutoresizingMaskIntoConstraints = false
        bTableView.dataSource = self
        bTableView.delegate = self
        bTableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.cellName)
        bTableView.backgroundColor = .systemGray6
        bTableView.separatorStyle = .none
        return bTableView
    }()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Variables
    var viewModel: HomeBooksViewModelProtocol
    private var inputViewModel = HomeBooksViewModelInput()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    init(viewModel: HomeBooksViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupSearchController()
        bind()
    }

    // MARK: - Private Methods
    private func setupController() {
        view.addSubview(booksTableView)
        view.backgroundColor = .white
        title = "Books"
        
        NSLayoutConstraint.activate([
            booksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            booksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            booksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            booksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"),
                                            style: .plain, target: self,
                                            action: #selector(goToFavorite))
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bind() {
        let output = viewModel.bind(input: inputViewModel)
        
        output.showFetchResultsPublisher.sink { [weak self] in
            self?.fillWithData()
        }.store(in: &cancellable)
        
        output.showFavoriteChangePublisher.sink { [weak self] indexPath in
            self?.changeFavorite(for: indexPath)
        }.store(in: &cancellable)
    }
    
    private func fillWithData() {
        UIView.transition(with: booksTableView,
                          duration: 0.3,
                          options: .transitionCrossDissolve) {
            self.booksTableView.reloadData()
        }
    }
    
    private func reloadCell(indexPath: IndexPath) {
        self.booksTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc private func goToFavorite() {
        print("Favorite")
    }
    
    private func changeFavorite(for indexPath: IndexPath) {
        let cell = booksTableView.cellForRow(at: indexPath) as? BookTableViewCell
        cell?.changeFavorite(book: viewModel.booksList.items[indexPath.row])
    }
}

// MARK: - TableView Functions
extension HomeBooksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.booksList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellName, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? BookTableViewCell {
            cell.configure(book: viewModel.booksList.items[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.35 * 1.5 + 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputViewModel.changeFavoritePublisher.send(indexPath)
    }
}

// MARK: - SearchController Functions
extension HomeBooksViewController: UISearchResultsUpdating {
     
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText =  searchController.searchBar.text, searchText != "" else {
            inputViewModel.cleanBooksListPublisher.send()
            return
        }
        
        inputViewModel.fetchBooksPublisher.send(searchText)
    }
}
