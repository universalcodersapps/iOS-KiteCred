//
//  JsonLoader.swift
//  KiteCred
//
//  Created by Amrita Jaiswal on 10/05/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation

public class JsonLoader {
    
    @Published var languageData = [LanguageData]()
    
    init() {
        load()
        sort()
    }
    
    func load() {
        
        if let fileLocation = Bundle.main.url(forResource: "Language", withExtension: "json") {
            
            // do catch in case of an error
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([LanguageData].self, from: data)
                
                self.languageData = dataFromJson
            } catch {
                print(error)
            }
        }
    }
    
    func sort() {
        self.languageData = self.languageData.sorted(by: { $0.id < $1.id })
    }
}
