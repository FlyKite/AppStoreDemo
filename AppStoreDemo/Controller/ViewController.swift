//
//  ViewController.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/9/26.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let searchBar: UISearchBar = UISearchBar()
    private let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(view.layoutMarginsGuide)
            }
            make.left.right.equalToSuperview()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = colorResource.color(for: .background)
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

