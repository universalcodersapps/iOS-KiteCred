//
//  MessageModel.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 01/05/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation
import UIKit

enum ButtonType {
    case noInternet
    case networkFailure
    case parsingError
    case sucesses
}

struct MessageModel {
    var imageName: String
    var title: String
    var message: String
    var font: UIFont
    var buttonType: ButtonType
}
