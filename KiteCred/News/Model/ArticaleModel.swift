//
//  ArticaleModel.swift
//  Kite
//
//  Created by Dileep Jaiswal on 10/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Realm
import RealmSwift

class ArticaleModel: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var summary: String = ""
    @objc dynamic var source: String = ""
    @objc dynamic var media_url: String = ""
    @objc dynamic var full_url: String = ""
    @objc dynamic var updated_at: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case source
        case media_url
        case full_url
        case updated_at
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        summary = try container.decode(String.self, forKey: .summary)
        source = try container.decode(String.self, forKey: .source)
        media_url = try container.decode(String.self, forKey: .media_url)
        full_url = try container.decode(String.self, forKey: .full_url)
        updated_at = try container.decode(String.self, forKey: .updated_at)
    }
}
