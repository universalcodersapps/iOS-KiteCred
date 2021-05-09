//
//  CategoryTableView.swift
//  Kite
//
//  Created by Dileep Jaiswal on 17/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

protocol CategoryTableViewDelegate {
    func tableView(_didSelectRowAt indexPath: IndexPath, model: CategoryModel)
}

class CategoryTableView: UITableView {
    var modelView = CategoryModelView()
    var categoryDelegte: CategoryTableViewDelegate?
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red: 0.0863, green: 0.1333, blue: 0.2353, alpha: 0.95)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit(){
        delegate = self
        dataSource = self
        allowsSelection = true
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 1, y: UIDevice.isPad ? 100 : 70, width: 180, height: UIDevice.isPad ? 70 : 50))
        headerView.backgroundColor = .clear
        let headerLabel: UILabel = UILabel.init(frame: CGRect.init(x: 15, y: 20, width: 180, height: 30))
        headerLabel.text = "Category"
        headerLabel.textColor = .white
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: UIDevice.isPad ? 25.0 : 17.0)
        headerView.addSubview(headerLabel)
        self.tableHeaderView = headerView
        loadCategoryData()
        modelView.delegate = self
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset =  CGSize.zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
    }
    
    func loadCategoryData() {
        modelView.fetchCategoryList()
    }
    
    func show() {
        UIView.animate(withDuration: 0.25,
               delay: 0.0,
               options: UIView.AnimationOptions.curveEaseInOut,
               animations: {
                    self.frame.origin.x = 0
            },completion: { finished in
                    
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25,
               delay: 0.0,
               options: UIView.AnimationOptions.curveEaseInOut,
               animations: {
                self.frame.origin.x = UIDevice.isPad ? -220 : -180
            },completion: { finished in
                    
        })
    }
}

extension CategoryTableView: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return modelView.categoryCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        let category = modelView.getCategoryWith(index: indexPath.row)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CELL")
            cell!.backgroundColor = .clear
            cell!.textLabel?.font = UIFont(name:"HelveticaNeue", size: UIDevice.isPad ? 23.0 : 15.0)
            cell!.textLabel?.textColor = UIColor.white
            cell!.selectionStyle = .none
        }
        cell!.textLabel?.text = category.title
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPad ? 80.0 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = modelView.getCategoryWith(index: indexPath.row)
        categoryDelegte?.tableView(_didSelectRowAt: indexPath, model: category)
    }
}

extension CategoryTableView: CategoryModelViewDelegate {
    func loadCategorySuccessfully() {
        DispatchQueue.main.async {
            self.reloadData()
            self.tableFooterView = UIView()
        }
    }
    
    func loadCategoryFailure() {

    }
}
