//
//  LanguageSelectionVController.swift
//  KiteCred
//
//  Created by Amrita Jaiswal on 10/05/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

class LanguageSelectionVController: UIViewController {
    
    @IBOutlet weak var languageNameView: UIView!
    @IBOutlet weak var langTableView: UITableView!
    let languageList = JsonLoader().languageData
    
    var count: Int {
        return languageList.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    func initialSetup() {
        navigationController?.isNavigationBarHidden = true
        langTableView.delegate = self
        langTableView.dataSource = self
        langTableView.separatorStyle = .none
        langTableView.reloadData()
        setViewLayer()
    }
    
    func setViewLayer() {
        languageNameView.layer.cornerRadius = 8.0
        langTableView.layer.cornerRadius = 8.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        langTableView.frame.size.height = 60.0 * CGFloat(count)
        
    }
}

extension LanguageSelectionVController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTVCell", for: indexPath) as! LanguageTVCell
        let language = languageList[indexPath.row]
        cell.langName.text = language.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPad ? 70 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LanguageTVCell
        cell.backgroundView?.backgroundColor = .white
        cell.checkMarkImageView.isHidden = false
    }
    
    
}
