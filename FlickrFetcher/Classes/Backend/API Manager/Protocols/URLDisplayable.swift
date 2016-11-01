//
//  URLDisplayable.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

protocol URLDisplayable {
    var standardPhotoUrl: URL { get }
    var largeSquarePhotoUrl: URL { get }
    var mediumPhotoUrl: URL { get }
}
