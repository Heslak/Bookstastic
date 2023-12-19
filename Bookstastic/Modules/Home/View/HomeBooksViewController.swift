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
        bTableView.register(BookTableViewCell.self,
                            forCellReuseIdentifier: BookTableViewCell.cellName)
        bTableView.register(FavoriteHeaderFooterView.self,
                            forHeaderFooterViewReuseIdentifier: FavoriteHeaderFooterView.viewName)
        bTableView.backgroundColor = .systemGray6
        bTableView.separatorStyle = .none
        return bTableView
    }()
    
    private lazy var pagingView: PagingView = {
        let pView = PagingView()
        pView.translatesAutoresizingMaskIntoConstraints = false
        pView.alpha = 0.0
        return pView
    }()
    
    var searchController = UISearchController(searchResultsController: nil)
    var searchTask: DispatchWorkItem?
    
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
        inputViewModel.viewDidLoadPublisher.send()
    }

    // MARK: - Private Methods
    private func setupController() {
        view.addSubview(booksTableView)
        view.addSubview(pagingView)
        view.backgroundColor = .systemGray6
        title = "Books"
        
        NSLayoutConstraint.activate([
            booksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            booksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            booksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pagingView.topAnchor.constraint(equalTo: booksTableView.bottomAnchor),
            pagingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingView.heightAnchor.constraint(equalToConstant: 48.0),
            pagingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        inputViewModel.increaseCounterPublisher = pagingView.increaseCounterPublisher
        inputViewModel.decreaseCounterPublisher = pagingView.decreaseCounterPublisher
        
        let output = viewModel.bind(input: inputViewModel)
        
        output.showFetchResultsPublisher.sink { [weak self] in
            self?.fillWithData()
        }.store(in: &cancellable)
        
        output.showFavoriteChangePublisher.sink { [weak self] indexPath in
            self?.changeFavorite(for: indexPath)
        }.store(in: &cancellable)
    }
    
    private func fillWithData() {
        DispatchQueue.main.async {
            UIView.transition(with: self.booksTableView,
                              duration: 0.3,
                              options: .transitionCrossDissolve) {
                self.booksTableView.reloadData()
            }
            
            self.pagingView.updateCounter(current: (self.viewModel.currentIndex/10 + 1),
                                     totalItems: self.viewModel.booksList.items.count)
        }
    }
    
    private func reloadCell(indexPath: IndexPath) {
        self.booksTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func changeFavorite(for indexPath: IndexPath) {
        if searchController.isActive {
            let cell = booksTableView.cellForRow(at: indexPath) as? BookTableViewCell
            cell?.changeFavorite(book: viewModel.booksList.items[indexPath.row])
        } else {
            viewModel.booksList.items.remove(at: indexPath.row)
            booksTableView.deleteRows(at: [indexPath], with: .left)
            fillWithData()
        }
    }
    
    private func hideOrShowPaging() {
        UIView.transition(with: booksTableView,
                          duration: 0.3,
                          options: .transitionCrossDissolve) {
            let hideOrShow = self.viewModel.booksList.items.count == 0 && self.viewModel.currentIndex == 0
            self.pagingView.alpha = hideOrShow ? 0.0 : 1.0
        }
    }
}

// MARK: - TableView Functions
extension HomeBooksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hideOrShowPaging()
        return viewModel.booksList.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = searchController.isActive ? "Results" : "Favorites"
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavoriteHeaderFooterView.viewName) as? FavoriteHeaderFooterView
        header?.configure(title: title)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellName, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if let cell = cell as? BookTableViewCell {
            cell.configure(book: viewModel.booksList.items[indexPath.row],
                           changeFavoritePublisher: inputViewModel.changeFavoritePublisher,
                           indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.35 * 1.5 + 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.booksList.items[indexPath.row]
        let controller = BookDetailSceneBuilder().build(book: book)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SearchController Functions
extension HomeBooksViewController: UISearchResultsUpdating {
     
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        let isActive = searchController.isActive
        searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
           DispatchQueue.global(qos: .userInteractive).async { [weak self] in
               guard searchText != "" else {
                   self?.inputViewModel.cleanBooksListPublisher.send(isActive)
                   return
               }
               
               self?.inputViewModel.fetchBooksPublisher.send(searchText)
           }
         }
        
         self.searchTask = task
         
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}
