//
//  CategoryModelView.swift
//  Kite
//
//  Created by Dileep Jaiswal on 17/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation

protocol CategoryModelViewDelegate {
    func loadCategorySuccessfully()
    func loadCategoryFailure()
}

class CategoryModelView {
    var delegate: CategoryModelViewDelegate?
    var apiClient = APIClient()
    
    func fetchCategoryList() {
        let apiData = CategoryRequest()
        apiClient.fetch(request: apiData, basePath: NetworkConstant.API.url, success: { (data, result) in
            self.parse(dataResponse: data)
        }) { (data, result, error) in
            
        }
    }
    
    func parse(dataResponse: Data) {
        do {
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            let item = try decoder.decode([CategoryModel].self, from: dataResponse) //Decode JSON Response Data
            RealmManager.shared.add(item)
            self.delegate?.loadCategorySuccessfully()
        } catch let parsingError {
            print("Error", parsingError)
            self.delegate?.loadCategoryFailure()
        }
    }
    
    func categoryCount() -> Int {
        return RealmManager.shared.itemsCount(with: CategoryModel.self, filter: .id)
    }
    
    func getCategoryWith(index: Int) -> CategoryModel {
        return RealmManager.shared.getItems(with: CategoryModel.self, index: index, ascending: true, filter: .id)!
    }
}

