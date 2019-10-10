//
//  ApiManager.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/9/30.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum AppStoreLocale: String {
    case cn
    case hk
}

enum Api: URLConvertible {
    
    case topGrossing(locale: AppStoreLocale, count: Int)
    case topFree(locale: AppStoreLocale, count: Int)
    case lookUp(appId: String, locale: AppStoreLocale)
    
    var urlString: String {
        switch self {
        case let .topGrossing(locale, count):
            return "https://itunes.apple.com/\(locale.rawValue)/rss/topgrossingapplications/limit=\(count)/json"
        case let .topFree(locale, count):
            return "https://itunes.apple.com/\(locale.rawValue)/rss/topfreeapplications/limit=\(count)/json"
        case let .lookUp(appId, locale):
            return "https://itunes.apple.com/\(locale.rawValue)/lookup?id=\(appId)"
        }
    }
    
}

extension Api {
    func asURL() throws -> URL {
        return try urlString.asURL()
    }
}

enum RequestError: Error {
    case serializationJSONFailure
    case networkFailue(statusCode: Int, error: Error)
    
    var localizedDescription: String {
        switch self {
        case .serializationJSONFailure: return "JSON序列化失败"
        case let .networkFailue(statusCode, error):
            print(error)
            return "网络异常:\(statusCode)"
        }
    }
}

typealias DataResult = Swift.Result<Data, RequestError>
typealias JSONResult = Swift.Result<JSON, RequestError>

class ApiManager {
    
    static func request(api: Api, completion: ((JSONResult) -> Void)?) {
        let task = Alamofire.request(api)
        task.responseData { (dataResponse) in
            switch dataResponse.result {
            case let .success(response):
                do {
                    let json = try JSON(data: response, options: .allowFragments)
                    completion?(.success(json))
                } catch {
                    completion?(.failure(.serializationJSONFailure))
                }
            case let .failure(error):
                completion?(.failure(.networkFailue(statusCode: dataResponse.response?.statusCode ?? -1, error: error)))
            }
        }
        task.resume()
    }
    
    static func requestData(api: Api, completion: ((DataResult) -> Void)?) {
        let task = Alamofire.request(api)
        task.responseData { (dataResponse) in
            switch dataResponse.result {
            case let .success(response): completion?(.success(response))
            case let .failure(error): completion?(.failure(.networkFailue(statusCode: dataResponse.response?.statusCode ?? -1, error: error)))
            }
        }
        task.resume()
    }
    
}
