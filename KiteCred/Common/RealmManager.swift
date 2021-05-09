//
//  RealmManager.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 24/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation
import RealmSwift

let realmObject = try! Realm()

class RealmManager: NSObject {
    
    static let shared = RealmManager()  
    
    func retrieveAllDataForObject(_ T : Object.Type) -> [Object] {
        
        var objects = [Object]()
        for result in realmObject.objects(T) {
            objects.append(result)
        }
        return objects
    }
    
    func deleteAllDataForObject(_ T : Object.Type) {
        
        self.delete(self.retrieveAllDataForObject(T))
    }
    
    func replaceAllDataForObject(_ T : Object.Type, with objects : [Object]) {
        
        deleteAllDataForObject(T)
        add(objects)
    }
    
    func add(_ objects : [Object]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(objects, update: .modified)
        }
    }
    
    func queryObjects<T: Object>(with type: T.Type, ascending: Bool, filter: Filter) throws -> Results<T> {
        let realm = try Realm()
        return realm.objects(T.self).sorted(byKeyPath: filter.rawValue, ascending: ascending)
    }
    
    func hasItems<T: Object>(with type: T.Type, filter: Filter) -> Bool {
        do {
            let objects = try queryObjects(with: T.self, ascending: false, filter: filter).map { $0 }
            return objects.count > 0 ? true : false
        } catch {
            return false
        }
    }
    
    func itemsCount<T: Object>(with type: T.Type, filter: Filter) -> Int {
        do {
            let objects = try queryObjects(with: T.self, ascending: false, filter: filter).map { $0 }
            return objects.count
        } catch {
            return 0
        }
    }
    
    func getItems<T: Object>(with type: T.Type, index: Int, ascending: Bool, filter: Filter) -> T? {
        do {
            let objects = try queryObjects(with: T.self, ascending: ascending, filter: filter).map { $0 }
            return (objects.count > 0) ? objects[index] : nil
        } catch {
            return nil
        }
    }
    
    func add(_ objects : [Object], completion : @escaping() -> ()) {
        
        try! realmObject.write {
            
            realmObject.add(objects)
            completion()
        }
    }
    
    func update(_ block: @escaping ()->Void) {
        
        try! realmObject.write(block)
    }
    
    func delete(_ objects : [Object]) {
        
        try! realmObject.write{
            realmObject.delete(objects)
        }
    }
}

enum Filter: String {
    case id = "id"
    case updatedAt = "updated_at"
}
