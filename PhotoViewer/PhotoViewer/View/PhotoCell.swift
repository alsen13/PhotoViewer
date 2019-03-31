//
//  PhotoCell.swift
//  PhotoViewer
//
//  Created by admin on 3/30/19.
//  Copyright © 2019 Alexey Sen. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var imageURL: String? {
        didSet {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                photoImageView.kf.setImage(with: url)
            } else {
                photoImageView.image = nil
                photoImageView.kf.cancelDownloadTask()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageURL = nil
    }
    
}












