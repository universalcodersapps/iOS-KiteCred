//
//  NewsDisplayView.swift
//  Kite
//
//  Created by Dileep Jaiswal on 11/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

protocol NewsDisplayViewDelegate: class {
    func refreshButtonAction(_ sender: UIButton)
    func sideBarButtonAction(_ sender: UIButton)
}

class NewsDisplayView: UIView {

    // MARK: -IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var pageImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var readMoreLabel: UILabel!
    var delegate: NewsDisplayViewDelegate?
    var viewHidden = true
    
    // MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NewsDisplayView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setViewTopCorner()
        showHideView(hidden: viewHidden)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        contentView.addGestureRecognizer(tap)
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        self.delegate?.refreshButtonAction(sender)
    }
    
    @IBAction func sideBarButtonTapped(_ sender: UIButton) {
        self.delegate?.sideBarButtonAction(sender)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        viewHidden = !viewHidden
        showHideView(hidden: viewHidden)
    }
    
    func loadViewData(articale: ArticaleModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = articale.title
            self.summaryLabel.text = articale.summary
            self.readMoreLabel.text = "Read more at \(articale.source)"
            self.pageImageView.downloaded(from: articale.media_url)
            
        }
    }
    
    func showHideView(hidden: Bool) {
        topView.isHidden = hidden
        bottomView.isHidden = hidden
    }
    
    func setViewTopCorner() {
    
    }
}
