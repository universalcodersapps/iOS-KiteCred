//
//  MessageViewController.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 01/05/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

protocol MessageViewCDelegate {
    func backButtonPressed()
    func tryAgain()
}
class MessageViewController: UIViewController {
    
    var delegate: MessageViewCDelegate?
    var messageModel: MessageModel?
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        guard let messageObj = messageModel else { return }
        let buttonTitle = getButtonTitle(buttonYype: messageObj.buttonType)
        messageImageView.image = UIImage(named: messageObj.imageName)
        titleLabel.text = messageObj.title
        titleLabel.font = messageObj.font
        descLabel.text = messageObj.message
        tryButton.setTitle(buttonTitle, for: .normal)
    }
    
    func getButtonTitle(buttonYype: ButtonType) -> String{
        switch buttonYype {
        case .noInternet:
            closeButton.isHidden = true
            return "Try Again"
        case .networkFailure:
            return "Go Back"
        case .parsingError:
            return "Go Back"
        case .sucesses:
            return "Refresh"
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.backButtonPressed()
        }
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        switch messageModel?.buttonType {
        case .noInternet:
            self.delegate?.tryAgain()
        case .networkFailure:
            self.dismiss(animated: true) {
                self.delegate?.backButtonPressed()
            }
        case .parsingError:
            self.dismiss(animated: true) {
                self.delegate?.backButtonPressed()
            }
        case .sucesses:
            self.dismiss(animated: true) {
                self.delegate?.backButtonPressed()
            }
        case .none:
            print("")
        }
    }
    
}
