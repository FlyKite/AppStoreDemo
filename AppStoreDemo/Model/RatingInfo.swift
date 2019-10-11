//
//  RatingInfo.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/10/10.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit

class RatingInfo: Codable {
    var averageUserRatingForCurrentVersion: Double = 0
    var userRatingCountForCurrentVersion: Int = 0
    
    var averageUserRating: Double = 0
    var userRatingCount: Int = 0
    
    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        averageUserRatingForCurrentVersion <- map[.averageUserRatingForCurrentVersion]
        userRatingCountForCurrentVersion <- map[.userRatingCountForCurrentVersion]
        averageUserRating <- map[.averageUserRating]
        userRatingCount <- map[.userRatingCount]
    }
}

class RatingGetter {
    
    let appId: String
    
    private var ratingInfo: RatingInfo?
    private let queue: DispatchQueue = DispatchQueue(label: "com.FlyKite.RatingGetter")
    private let group: DispatchGroup = DispatchGroup()
    
    init(appId: String) {
        self.appId = appId
    }
    
    func loadRatingInfo(completion: ((RatingInfo?) -> Void)?) {
        queue.async {
            self.group.wait()
            self.group.enter()
            if let ratingInfo = self.ratingInfo {
                DispatchQueue.main.async {
                    completion?(ratingInfo)
                    self.group.leave()
                }
            } else {
                ApiManager.request(api: Api.lookUp(appId: self.appId, locale: .cn)) { (result) in
                    switch result {
                    case let .success(json):
                        let ratingInfo = [RatingInfo].map(from: json["results"])?.first
                        self.ratingInfo = ratingInfo
                        completion?(ratingInfo)
                    case let .failure(error):
                        print(error)
                        completion?(nil)
                    }
                    self.group.leave()
                }
            }
        }
    }
    
}
