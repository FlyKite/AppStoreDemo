//
//  RecommendAppCell.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/9/30.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit

class RecommendAppCell: UICollectionViewCell {
    
    func update(title: String, type: String, iconUrl: URL?) {
        appIconImageView.kf.setImage(with: iconUrl)
        appTitleLabel.text = title
        appTypeLabel.text = type
    }
    
    private let appIconImageView: UIImageView = UIImageView()
    private let appTitleLabel: UILabel = UILabel()
    private let appTypeLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        appIconImageView.layer.cornerRadius = 18
        appIconImageView.clipsToBounds = true
        
        appTitleLabel.font = UIFont.systemFont(ofSize: 12)
        appTitleLabel.numberOfLines = 2
        
        appTypeLabel.font = UIFont.systemFont(ofSize: 10)
        
        contentView.addSubview(appIconImageView)
        contentView.addSubview(appTitleLabel)
        contentView.addSubview(appTypeLabel)
        
        appIconImageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(appIconImageView.snp.width)
        }
        
        appTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appIconImageView.snp.bottom).offset(8)
            make.left.equalTo(appIconImageView)
            make.right.lessThanOrEqualTo(appIconImageView)
        }
        
        appTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appTitleLabel.snp.bottom).offset(4)
            make.left.equalTo(appIconImageView)
            make.right.lessThanOrEqualTo(appIconImageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = colorResource.color(for: .background)
        appTitleLabel.textColor = colorResource.color(for: .textColor)
        appTypeLabel.textColor = colorResource.color(for: .detailTextColor)
    }
    
}
