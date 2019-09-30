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
    private let loadingView: UIActivityIndicatorView = {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView(style: .large)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
    
    private var originalAppInfoList: [TopFreeApp] = []
    private var appInfoList: [TopFreeApp] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    private func setupViews() {
        
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        searchBar.isHidden = true
        
        tableView.register(AppItemCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 88
        tableView.isHidden = true
        tableView.keyboardDismissMode = .onDrag
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        
        searchBar.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(view.layoutMarginsGuide)
            }
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = colorResource.color(for: .background)
        tableView.backgroundColor = colorResource.color(for: .background)
    }
    
    private func loadData() {
        loadingView.startAnimating()
        ApiManager.request(api: Api.topFree(locale: .cn, count: 100)) { (result) in
            self.loadingView.stopAnimating()
            switch result {
            case let .success(json):
                guard let appInfoList = [TopFreeApp].map(from: json["feed"]["entry"]) else { return }
                self.originalAppInfoList = appInfoList
                self.appInfoList = appInfoList
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.searchBar.isHidden = false
                self.loadingView.isHidden = true
            case let .failure(error): print(error)
            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AppItemCell.self, for: indexPath)
        let info = appInfoList[indexPath.row]
        cell.update(title: info.name, type: info.category, iconUrl: info.images.last?.url, index: indexPath.row)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = appInfoList[indexPath.row]
        if let url = info.appStoreUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            appInfoList = originalAppInfoList
        } else {
            appInfoList = originalAppInfoList.filter({ (info) -> Bool in
                return info.name.contains(searchText)
            })
        }
        tableView.reloadData()
    }
}

