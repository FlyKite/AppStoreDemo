//
//  RetryView.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/9/30.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit

class RetryView: UIView {
    
    var retryAction: (() -> Void)?
    
    private let retryLabel: UILabel = UILabel()
    private let retryButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        retryLabel.text = "无法连接App Store"
        retryLabel.font = UIFont.systemFont(ofSize: 18)
        
        retryButton.setTitle("重试", for: .normal)
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        retryButton.addTarget(self, action: #selector(retryButtonClicked), for: .touchUpInside)
        retryButton.layer.borderWidth = 0.5
        
        addSubview(retryLabel)
        addSubview(retryButton)
        
        retryLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        }
        
        retryButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(retryLabel.snp.bottom).offset(16)
            make.width.equalTo(96)
            make.height.equalTo(36)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        retryLabel.textColor = colorResource.color(for: .textColor)
        retryButton.setTitleColor(colorResource.color(for: .textColor), for: .normal)
        retryButton.layer.borderColor = colorResource.color(for: .textColor).cgColor
    }
    
    @objc private func retryButtonClicked() {
        retryAction?()
    }

}
