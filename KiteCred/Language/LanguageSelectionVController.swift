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
    var selectedLang: LanguageData?
    
    var count: Int {
        return languageList.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientBackground()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.1059, green: 0.1176, blue: 0.2941, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.1451, green: 0.2431, blue: 0.3843, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
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
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        guard let language = selectedLang else {
            SnackbarView.shared.showAlert(message: NetworkConstant.Snackbar.language, alertType: .hideAction, to: self)
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(language.code, forKey: "languageCode")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
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
        selectedLang = languageList[indexPath.row]
    }
    
    
}
