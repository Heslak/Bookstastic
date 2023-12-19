//
//  HomeBooksViewController.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import UIKit
import Combine

class HomeBooksViewController: UIViewController {
    
    typealias Strings = HomeBooksStrings
    // MARK: - UI Components
    
    
    private lazy var verticalStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.distribution = .fill
        return vStackView
    }()
    
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
        pView.isHidden = true
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
    
    override func viewDidAppear(_ animated: Bool) {
        inputViewModel.viewDidAppearPublisher.send(searchController.isActive)
    }

    // MARK: - Private Methods
    private func setupController() {
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(booksTableView)
        verticalStackView.addArrangedSubview(pagingView)
        view.backgroundColor = .systemGray6
        title = Strings.homeTitle
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Strings.search
        
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
        
        output.showErrorAlertPublisher.sink { [weak self] in
            self?.showErrorAlert()
        }.store(in: &cancellable)
    }
    
    private func fillWithData() {
        DispatchQueue.main.async {
            UIView.transition(with: self.booksTableView,
                              duration: 0.3,
                              options: .transitionCrossDissolve) {
                self.booksTableView.reloadData()
            } completion: { _ in
                self.hideOrShowPaging()
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
        let hideOrShow = !self.searchController.isActive
        self.pagingView.isHidden = hideOrShow
    }
    
    private func hideOrShowEmptyView(itemsCount: Int) {
        let emptyView = EmptyView()
        let message = searchController.isActive ? Strings.messageEmptySearching : Strings.messageEmptyFavorites
        emptyView.configure(message: message)
        booksTableView.backgroundView = itemsCount == 0 ? emptyView : nil
    }
        
    private func showErrorAlert() {
        let title = Strings.errorTitle
        let message = Strings.errorMessage
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let accept = UIAlertAction(title: Strings.errorAccept, style: .default)
        alert.addAction(accept)
        
        present(alert, animated: true)
    }
}

// MARK: - TableView Functions
extension HomeBooksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hideOrShowEmptyView(itemsCount: viewModel.booksList.items.count)
        return viewModel.booksList.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = searchController.isActive ? Strings.resultTitle : Strings.favoritesTitle
        let viewName = FavoriteHeaderFooterView.viewName
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewName) as? FavoriteHeaderFooterView
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
