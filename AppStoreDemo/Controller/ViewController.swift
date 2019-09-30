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
    
    private let recommendLabel: UILabel = UILabel()
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let separator: UIView = UIView()
    private let recommendRetryView: RetryView = RetryView()
    private let recommendLoadingView: UIActivityIndicatorView = {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView(style: .large)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
    
    private let tableView: UITableView = UITableView()
    private let topFreeRetryView: RetryView = RetryView()
    private let loadingView: UIActivityIndicatorView = {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView(style: .large)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
    
    private var originalRecommendAppList: [TopFreeApp] = []
    private var recommendAppList: [TopFreeApp] = []
    
    private var originalAppList: [TopFreeApp] = []
    private var appList: [TopFreeApp] = []

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
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 194))
        
        recommendLabel.text = "推荐"
        recommendLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 72, height: 128)
        
        collectionView.register(RecommendAppCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        recommendRetryView.retryAction = { [weak self] in
            self?.loadRecommendApp()
        }
        
        tableView.tableHeaderView = headerView
        
        topFreeRetryView.retryAction = { [weak self] in
            self?.loadTopFreeApp()
        }
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(topFreeRetryView)
        headerView.addSubview(recommendLabel)
        headerView.addSubview(collectionView)
        headerView.addSubview(separator)
        headerView.addSubview(recommendLoadingView)
        headerView.addSubview(recommendRetryView)
        
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
        
        topFreeRetryView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        recommendLabel.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.left.equalTo(headerView.safeAreaLayoutGuide).offset(16)
            } else {
                make.left.equalTo(headerView.layoutMarginsGuide).offset(16)
            }
            make.top.equalToSuperview().offset(16)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.right.equalToSuperview()
            make.height.equalTo(128)
        }
        
        separator.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
        
        recommendRetryView.snp.makeConstraints { (make) in
            make.edges.equalTo(collectionView)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = colorResource.color(for: .background)
        collectionView.backgroundColor = colorResource.color(for: .background)
        separator.backgroundColor = colorResource.color(for: .separator)
        tableView.backgroundColor = colorResource.color(for: .background)
        recommendLabel.textColor = colorResource.color(for: .textColor)
    }
    
    private func loadData() {
        loadTopFreeApp()
        loadRecommendApp()
    }
    
    private func loadTopFreeApp() {
        topFreeRetryView.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
        ApiManager.request(api: Api.topFree(locale: .cn, count: 100)) { (result) in
            self.loadingView.stopAnimating()
            self.loadingView.isHidden = true
            switch result {
            case let .success(json):
                guard let appList = [TopFreeApp].map(from: json["feed"]["entry"]) else { return }
                self.originalAppList = appList
                self.appList = appList
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.searchBar.isHidden = false
            case let .failure(error):
                self.topFreeRetryView.isHidden = false
                print(error)
            }
        }
    }
    
    private func loadRecommendApp() {
        recommendRetryView.isHidden = true
        recommendLoadingView.isHidden = false
        recommendLoadingView.startAnimating()
        ApiManager.request(api: Api.topGrossing(locale: .cn, count: 10)) { (result) in
            self.recommendLoadingView.stopAnimating()
            self.recommendLoadingView.isHidden = true
            switch result {
            case let .success(json):
                guard let appList = [TopFreeApp].map(from: json["feed"]["entry"]) else { return }
                self.originalRecommendAppList = appList
                self.recommendAppList = appList
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
            case let .failure(error):
                self.recommendRetryView.isHidden = false
                print(error)
            }
        }
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            appList = originalAppList
            recommendAppList = originalRecommendAppList
        } else {
            appList = originalAppList.filter({ (info) -> Bool in
                return info.name.contains(searchText)
            })
            recommendAppList = originalRecommendAppList.filter({ (info) -> Bool in
                return info.name.contains(searchText)
            })
        }
        collectionView.reloadData()
        tableView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendAppList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecommendAppCell.self, for: indexPath)
        let info = recommendAppList[indexPath.item]
        cell.update(title: info.name, type: info.category, iconUrl: info.images.last?.url)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let info = recommendAppList[indexPath.item]
        if let url = info.appStoreUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AppItemCell.self, for: indexPath)
        let info = appList[indexPath.row]
        cell.update(title: info.name, type: info.category, iconUrl: info.images.last?.url, index: indexPath.row)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = appList[indexPath.row]
        if let url = info.appStoreUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
