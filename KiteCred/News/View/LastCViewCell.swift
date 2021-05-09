//
//  LastCViewCell.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 02/05/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

protocol LastCViewCellDelegate {
    func backButtonPressed(_ sender: UIButton)
    func refreshButtonPressed(_ sender: UIButton)
}

class LastCViewCell: UICollectionViewCell {
    
    var delegate: LastCViewCellDelegate?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: MessageModel) {
        titleImageView.image = UIImage(named: message.imageName)
        titleLabel.text = message.title
        messageLabel.text = message.message
        
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        delegate?.backButtonPressed(sender)
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        delegate?.refreshButtonPressed(sender)
    }
    
}
