//
//  TrailersTableViewCell.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 3/11/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit

class TrailersTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var trailersCollectionView: UICollectionView!

    var youtubeTrailerIds: [String]? {
        didSet {
            trailersCollectionView.delegate = self
            trailersCollectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trailersCollectionView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: "thumbnailCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youtubeTrailerIds?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! TrailerCollectionViewCell
        
        let videoId = youtubeTrailerIds![indexPath.row]
        let thumbnailLink = URL(string: MovieDetailsViewController.kYoutTubeBaseImageUrl + videoId + "/0.jpg")
        cell.setThumbnail(url: thumbnailLink!)
        
        return cell
    }
}
