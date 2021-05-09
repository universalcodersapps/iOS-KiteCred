//
//  ItemHandler.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 22/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation

let searchIdentifier = "com.raywenderlich.appSearch"

class ItemHandler {
    static let sharedInstance = ItemHandler()
    
    var items: [NewsLink] = []
    
    private init() {
        loadJSON()
    }
    
    private func loadJSON() {
        // Load local JSON file
        guard let url = Bundle.main.url(forResource: "Items", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url, options: .uncached)
            let records = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String: String]]
            items = records.map { NewsLink(dict: $0) }
        } catch let error as NSError {
            print("JSON error: \(error)")
        }
    }
}

