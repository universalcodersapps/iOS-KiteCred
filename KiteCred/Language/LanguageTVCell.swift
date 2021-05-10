//
//  LanguageTVCell.swift
//  KiteCred
//
//  Created by Amrita Jaiswal on 10/05/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

class LanguageTVCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var langImageView: UIImageView!
    @IBOutlet weak var langName: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(imge: String, langName: String) {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
