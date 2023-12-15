//
//  HomeBooksViewController.swift
//  Bookstastic
//
//  Created by Sergio Acosta on 15/12/23.
//

import UIKit

class HomeBooksViewController: UIViewController {
    var viewModel: HomeBooksViewModelProtocol
    
    init(viewModel: HomeBooksViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

