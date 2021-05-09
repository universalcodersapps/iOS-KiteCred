//
//  CategoryModel.swift
//  Kite
//
//  Created by Dileep Jaiswal on 17/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryModel: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }
}



