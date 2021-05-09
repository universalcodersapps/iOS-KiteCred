//
//  NewsLink.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 22/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation
import UIKit


enum DeepLink: String {
    case home = "home"
    case scan = "scan"
}

class NewsLink {
    let id: String
    let name: String
    let path: String
    let link: String
    let imgLogo: UIImage
    let imgBoard: UIImage
    let description: String
    let vendor: String
    
    init(dict: [String: String]) {
        id = dict["id"] ?? "000"
        name = dict["name"] ?? "empty"
        path = dict["path"] ?? "empty"
        link = dict["link"] ?? "empty"
        imgLogo = UIImage(named: (dict["imgLogo"] ?? "empty.pdf")) ?? UIImage(named: "empty.pdf")!
        imgBoard = UIImage(named: (dict["imgBoard"] ?? "empty.pdf")) ?? UIImage(named: "empty.pdf")!
        description = dict["description"] ?? "empty"
        vendor = dict["vendor"] ?? "empty"
    }
}
