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
