//
//  NewsModelView.swift
//  Kite
//
//  Created by Dileep Jaiswal on 10/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation
import RealmSwift

protocol NewsModelViewDelegate {
    func dataLoadSuccessfully()
    func loadDataFailureWith(message: MessageModel)
    func failToLoadCategory(message: MessageModel)
}

class NewsModelView {
    var delegate: NewsModelViewDelegate?
    var apiClient = APIClient()
    var isOnline = false
    var articleList = [ArticaleModel]()
    
    func fetchNewsData() {
        let defaults = UserDefaults.standard
        guard let langCode = defaults.string(forKey: "languageCode") else {
            return
        }
        let apiData = NewsArticlesRequest.newsArticles(langCode)
        apiClient.fetch(request: apiData, basePath: NetworkConstant.API.url, success: { (data, result) in
            self.parse(dataResponse: data, isCategory: false)
        }) { (data, result, error) in
            let font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            let message = MessageModel(imageName: "", title: "Network Error", message: error.localizedDescription, font: font!, buttonType: .networkFailure)
            self.delegate?.loadDataFailureWith(message: message)
        }
    }
    
    func fetchCategoryNewsDataWith(id: Int) {
        let defaults = UserDefaults.standard
        guard let langCode = defaults.string(forKey: "languageCode") else {
            return
        }
        let apiData = NewsArticlesRequest.articlesWithCategory(id, langCode)
        apiClient.fetch(request: apiData, basePath: NetworkConstant.API.url, success: { (data, result) in
            self.parse(dataResponse: data, isCategory: true)
        }) { (data, result, error) in
            let font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            let message = MessageModel(imageName: "", title: "Network Error", message: error.localizedDescription, font: font!, buttonType: .networkFailure)
            self.delegate?.failToLoadCategory(message: message)
        }
    }
    
    func parse(dataResponse: Data, isCategory: Bool) {
        do {
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            let item = try decoder.decode([ArticaleModel].self, from: dataResponse)
            isOnline = isCategory
            if isOnline {
                self.articleList = item
            } else {
                RealmManager.shared.add(item)
            }
            //Decode JSON Response Data
            self.delegate?.dataLoadSuccessfully()
        } catch let parsingError {
            print("Error", parsingError)
            let font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            let message = MessageModel(imageName: "", title: "Parsing Error", message: parsingError.localizedDescription, font: font!, buttonType: .parsingError)
            self.delegate?.loadDataFailureWith(message: message)
        }
    }
    
    func getItemsWithSelectedId() {
        
    }

    func getArticlesCount() -> Int {
        return isOnline ? articleList.count : RealmManager.shared.itemsCount(with: ArticaleModel.self, filter: .updatedAt)
    }
    
    func getArticleWith(index: Int) -> ArticaleModel {
        return isOnline ? articleList[index] :  RealmManager.shared.getItems(with: ArticaleModel.self, index: index, ascending: false, filter: .updatedAt)!
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}

