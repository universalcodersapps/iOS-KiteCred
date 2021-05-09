//
//  NewsCollectionViewCell.swift
//  Kite
//
//  Created by Dileep Jaiswal on 17/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit
import SDWebImage

protocol NewsCollectionViewCellDelegate {
    func readMoreButtonTapped(sender: UITapGestureRecognizer)
}
class NewsCollectionViewCell: UICollectionViewCell {
    var delegate: NewsCollectionViewCellDelegate?
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSubtitleLabel: UILabel!
    @IBOutlet weak var readMoreLabel: UILabel!
    @IBOutlet weak var readMoreBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTapGesture()
        self.newsImageView.contentMode = .scaleAspectFill
    }
    
    func setTapGesture() {
        let readMoreViewTap = UITapGestureRecognizer(target: self, action: #selector(self.readMoreViewTap(_:)))
        self.readMoreBackView.addGestureRecognizer(readMoreViewTap)
    }
    
    @objc func readMoreViewTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.readMoreButtonTapped(sender: sender)
    }
    
    func configureCellWith(articale: ArticaleModel) {
        DispatchQueue.main.async {
            self.newsTitleLabel.text = articale.title
            self.newsSubtitleLabel.text = articale.summary
            self.readMoreLabel.text = "Read more at \(articale.source)"
            self.newsImageView.sd_setImage(with: URL(string: articale.media_url), placeholderImage: UIImage(named: "placeholder1"))
            //self.newsImageView.downloaded(from: articale.media_url)
        }
    }
    
}
