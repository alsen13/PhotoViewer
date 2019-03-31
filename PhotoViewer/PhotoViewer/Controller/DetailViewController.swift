//
//  DetailViewController.swift
//  PhotoViewer
//
//  Created by admin on 3/30/19.
//  Copyright © 2019 Alexey Sen. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController, UIScrollViewDelegate {

    var photo: Photo?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        if let photo = photo, let url = URL(string: photo.bigImage) {
            photoImageView.kf.setImage(with: url)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    

}
