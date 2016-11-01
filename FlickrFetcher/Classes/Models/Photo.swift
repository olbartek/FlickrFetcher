//
//  Photo.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation
import UIKit

enum APIPhotoState {
    case new, downloaded, failed
}

class Photo {
    
    var state: APIPhotoState = .new
    var image: UIImage?
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}
