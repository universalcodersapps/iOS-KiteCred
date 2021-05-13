//
//  NewsArticlesRequest.swift
//  Kite
//
//  Created by Dileep Jaiswal on 10/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation

enum NewsArticlesRequest {
    
    // MARK: User actions
    case newsArticles(_: String)
    case articlesWithCategory(_: Int, _: String)
}
extension NewsArticlesRequest: APIData {
    var path: String {
        switch self {
            
        case .newsArticles(let langCode):
            return "api/v1/news_articles?language=\(langCode)"
        case .articlesWithCategory(let id, let langCode):
            return "api/v1/news_articles?category_ids=\(id)?language=\(langCode)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .newsArticles:
            return .get
        default:
            return .get
        }
    }
    
    var parameters: RequestParams {
        return RequestParams(urlParameters: nil, bodyParameters: nil)
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var dataType: ResponseDataType {
        return .JSON
    }
    
    
}

