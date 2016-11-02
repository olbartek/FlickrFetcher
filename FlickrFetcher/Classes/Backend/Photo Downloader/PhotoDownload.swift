//
//  PhotoDownload.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import UIKit

class PhotoDownload: Operation {
    
    fileprivate weak var photo: Photo?
    fileprivate let realmManager: RealmManagerType
    
    init(photo: Photo, realmManager: RealmManagerType) {
        self.photo = photo
        self.realmManager = realmManager
    }
    
    override func main() {
        if isCancelled { return }
        guard let photo = photo else { return }
        
        var imageData: Data?
        
        imageData = realmManager.photoData(withUrl: photo.url)
        if imageData == nil {
            if let imgData = try? Data(contentsOf: photo.url) {
                imageData = imgData
                realmManager.createAndSavePhoto(withUrl: photo.url, imageData: imgData)
            }
        }
        guard let imageUnwrappedData = imageData else {
            photo.state = .failed
            return
        }
        
        if isCancelled { return }
        if imageUnwrappedData.count > 0 {
            photo.state = .downloaded
        } else {
            photo.state = .failed
        }
    }

}
