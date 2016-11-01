//
//  PhotoDownload.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import UIKit

class PhotoDownload: Operation {
    
    fileprivate var photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    override func main() {
        if isCancelled { return }
        guard let imageData = try? Data(contentsOf: photo.url) else {
            photo.state = .failed
            return
        }
        if isCancelled { return }
        if imageData.count > 0 {
            photo.image = UIImage(data: imageData)
            photo.state = .downloaded
        } else {
            photo.state = .failed
        }
    }

}
