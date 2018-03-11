//
//  TrailerCollectionViewCell.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 3/11/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit

class TrailerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    var thumbnailUrl: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let url = thumbnailUrl {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setThumbnail(url: URL) {
        thumbnailUrl = url
    }

}
