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
    case newsArticles
    case articlesWithCategory(_: Int)
}
extension NewsArticlesRequest: APIData {
    var path: String {
        switch self {
            
        case .newsArticles:
            return "api/v1/news_articles"
        case .articlesWithCategory(let id):
            return "api/v1/news_articles?category_ids=\(id)"
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

