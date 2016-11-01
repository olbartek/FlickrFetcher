//
//  PhotoCollectionViewCell.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 31/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.spinner.startAnimating()
    }
}
