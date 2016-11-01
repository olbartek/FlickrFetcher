//
//  RealmManagerType.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

protocol RealmManagerType: class {
    func createAndSavePhoto(withUrl url: URL, imageData: Data)
    func photoData(withUrl url: URL) -> Data?
}
