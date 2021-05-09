//
//  SnackbarView.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 02/05/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

enum AlertType {
    case showAction
    case hideAction
}

protocol SnackbarViewDelegate {
    func hideActionButton()
}

class SnackbarView: UIView {
    // MARK: -IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    var delegate: SnackbarViewDelegate?
    static let shared = SnackbarView()

    // MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()
    }
    
    func showAlert(message: String, alertType: AlertType, to: UIViewController) {
        switch alertType {
        case .showAction:
            actionButton.isHidden = false
            messageLabel.text = message
        case .hideAction:
            buttonWidthConstraint.constant = 0
            actionButton.isHidden = true
            messageLabel.text = message
        }
        let height = to.view.frame.size.height
        contentView.frame = CGRect(x: UIDevice.isPad ? 100 : 15, y: height + (UIDevice.isPad ? 40 : 10), width: to.view.frame.size.width - (UIDevice.isPad ? 200 :30), height: UIDevice.isPad ? 100 : 60)
        to.view.addSubview(contentView)
        setupLayout()
        show(height: height, to: to)
    }
    
    func hideAlert(to: UIViewController) {
        let height = to.view.frame.size.height
        hide(height: height, to: to)
    }
    
    func show(height: CGFloat, to: UIViewController) {
        to.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5,
               delay: 0.0,
               options: UIView.AnimationOptions.curveEaseInOut,
               animations: {
                self.contentView.frame.origin.y = height - (UIDevice.isPad ? 130 : 85)
            },completion: { finished in
                self.hide(height: height, to: to)
        })
    }
    
    func hide(height: CGFloat, to: UIViewController) {
        UIView.animate(withDuration: 0.8,
               delay: 1.5,
               options: UIView.AnimationOptions.curveEaseInOut,
               animations: {
                self.contentView.frame.origin.y = height + (UIDevice.isPad ? 20 : 10)
            },completion: { finished in
                to.view.isUserInteractionEnabled = true
        })
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SnackbarView", owner: self, options: nil)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupLayout() {
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 1
        contentView.layer.cornerRadius = 4.0
        contentView.isMultipleTouchEnabled = true
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        self.delegate?.hideActionButton()
    }
}
