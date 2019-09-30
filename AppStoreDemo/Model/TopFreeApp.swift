//
//  TopFreeApp.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/9/30.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit

class TopFreeApp: Codable {
    var appStoreUrl: URL?
    var id: String = ""
    var bundleId: String = ""
    
    var name: String = ""
    var images: [AppIcon] = []
    
    var categoryId: String = ""
    var category: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "im:name"
        case images = "im:image"
        case category
    }
    
    enum IdKeys: String, CodingKey {
        case id = "im:id"
        case bundleId = "im:bundleId"
    }
    
    enum ContentKeys: String, CodingKey {
        case label
        case attributes
    }
    
    enum CategoryKeys: String, CodingKey {
        case id = "im:id"
        case category = "label"
    }
    
    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let idMap = try map.nestedContainer(keyedBy: ContentKeys.self, forKey: .id)
            appStoreUrl <- idMap[.label]
            let attrMap = try idMap.nestedContainer(keyedBy: IdKeys.self, forKey: .attributes)
            id <- attrMap[.id]
            bundleId <- attrMap[.bundleId]
        } catch {
            print(error)
        }
        name <- (try? map.nestedContainer(keyedBy: ContentKeys.self, forKey: .name)[.label])
        images <- map[.images]
        do {
            let categoryMap = try map.nestedContainer(keyedBy: ContentKeys.self, forKey: .category)
            let attrMap = try categoryMap.nestedContainer(keyedBy: CategoryKeys.self, forKey: .attributes)
            categoryId <- attrMap[.id]
            category <- attrMap[.category]
        } catch {
            print(error)
        }
    }
}

class AppIcon: Codable {
    var url: URL?
    var height: String = ""
    
    enum CodingKeys: String, CodingKey {
        case url = "label"
        case height = "attributes"
    }
    
    enum ContentKeys: String, CodingKey {
        case height
    }
    
    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        url <- map[.url]
        height <- (try? map.nestedContainer(keyedBy: ContentKeys.self, forKey: .height)[.height])
    }
}
