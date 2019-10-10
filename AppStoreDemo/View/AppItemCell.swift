//
//  AppItemCell.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/9/30.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit
import Kingfisher

class AppItemCell: UITableViewCell {
    
    func update(title: String, type: String, iconUrl: URL?, index: Int) {
        indexLabel.text = "\(index + 1)"
        appIconImageView.layer.cornerRadius = index % 2 == 0 ? 16 : 32
        appIconImageView.kf.setImage(with: iconUrl)
        appTitleLabel.text = title
        appTypeLabel.text = type
    }
    
    func startLoadingRating() {
        ratingLabel.isHidden = true
        ratingCountLabel.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func stopLoadingRating(with ratingInfo: RatingInfo?) {
        loadingView.stopAnimating()
        loadingView.isHidden = true
        if let ratingInfo = ratingInfo {
            ratingLabel.isHidden = false
            ratingCountLabel.isHidden = false
            var ratingText = ""
            var rating = ratingInfo.averageUserRatingForCurrentVersion.rounded()
            for _ in 0 ..< 5 {
                if rating >= 1 {
                    ratingText.append("★")
                } else {
                    ratingText.append("☆")
                }
                rating -= 1
            }
            ratingLabel.text = ratingText
            ratingCountLabel.text = "(\(ratingInfo.userRatingCountForCurrentVersion))"
        }
    }
    
    private let indexLabel: UILabel = UILabel()
    private let appIconImageView: UIImageView = UIImageView()
    private let appTitleLabel: UILabel = UILabel()
    private let appTypeLabel: UILabel = UILabel()
    private let ratingLabel: UILabel = UILabel()
    private let ratingCountLabel: UILabel = UILabel()
    private let loadingView: UIActivityIndicatorView = {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView(style: .medium)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        indexLabel.text = "100"
        indexLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        indexLabel.textAlignment = .center
        
        appIconImageView.layer.cornerRadius = 12
        appIconImageView.clipsToBounds = true
        
        appTitleLabel.font = UIFont.systemFont(ofSize: 15)
        appTitleLabel.numberOfLines = 2
        
        appTypeLabel.font = UIFont.systemFont(ofSize: 13)
        
        ratingLabel.text = "☆"
        ratingLabel.font = UIFont.systemFont(ofSize: 10)
        ratingLabel.textColor = 0xFFBB2A.rgbColor
        
        ratingCountLabel.font = UIFont.systemFont(ofSize: 10)
        
        contentView.addSubview(indexLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(appTitleLabel)
        contentView.addSubview(appTypeLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(ratingCountLabel)
        contentView.addSubview(loadingView)
        
        indexLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
        }
        
        appIconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(indexLabel.snp.right)
            make.width.height.equalTo(64)
            make.centerY.equalToSuperview()
        }
        
        appTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appIconImageView)
            make.left.equalTo(appIconImageView.snp.right).offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        appTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appTitleLabel.snp.bottom).offset(4)
            make.left.equalTo(appIconImageView.snp.right).offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        ratingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appTypeLabel.snp.bottom).offset(2)
            make.left.equalTo(appIconImageView.snp.right).offset(8)
        }
        
        ratingCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ratingLabel.snp.right)
            make.centerY.equalTo(ratingLabel)
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.left.equalTo(ratingLabel)
            make.centerY.equalTo(ratingLabel)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = colorResource.color(for: .background)
        indexLabel.textColor = colorResource.color(for: .detailTextColor)
        ratingCountLabel.textColor = colorResource.color(for: .detailTextColor)
        appTitleLabel.textColor = colorResource.color(for: .textColor)
        appTypeLabel.textColor = colorResource.color(for: .detailTextColor)
    }

}
