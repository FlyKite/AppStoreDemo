//
//  CodableMapper.swift
//  Qitoto
//
//  Created by 风筝 on 2019/7/14.
//  Copyright © 2019 Doge's Studio. All rights reserved.
//

import UIKit
import SwiftyJSON

infix operator <-

extension KeyedDecodingContainer where Key: CodingKey {
    subscript<T: Codable>(key: Key) -> T? {
        do {
            return try self.decodeIfPresent(T.self, forKey: key)
        } catch {
            print("❌ Decode \(key) failed: ", error)
            return nil
        }
    }
    
    func map<T: Codable>(_ key: Key) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    func mapOptional<T: Codable>(_ key: Key) throws -> T? {
        return try self.decodeIfPresent(T.self, forKey: key)
    }
}

extension Decodable {
    
    static func <- (left: inout Self, right: Self?) {
        if let right = right {
            left = right
        }
    }
    
    // MARK: Convenient mapping functions
    
    static func map(from json: JSON?) -> Self? {
        guard let json = json else { return nil }
        return map(from: json)
    }
    
    static func map(from json: JSON) -> Self? {
        do {
            let data = try json.rawData()
            let model = try JSONDecoder().decode(Self.self, from: data)
            return model
        } catch {
            print("Decode \(String(describing: self)) failed: \(error)")
            return nil
        }
    }
    
    static func map(from jsonObject: Any) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            let model = try JSONDecoder().decode(Self.self, from: data)
            return model
        } catch {
            print("Decode \(String(describing: self)) failed: \(error)")
            return nil
        }
    }
    
    static func map(from jsonString: String) -> Self? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            let model = try JSONDecoder().decode(Self.self, from: data)
            return model
        } catch {
            print("Decode \(String(describing: self)) failed: \(error)")
            return nil
        }
    }
}
