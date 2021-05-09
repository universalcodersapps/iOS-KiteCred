//
//  CategoryRequest.swift
//  Kite
//
//  Created by Dileep Jaiswal on 17/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation

class CategoryRequest: APIData {
    
    var parameters: RequestParams {
        return RequestParams(urlParameters: ["" : ""], bodyParameters: nil)
    }
    
    var path: String {
        return "api/v1/categories"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var dataType: ResponseDataType {
        return .JSON
    }
    
    
}
 
