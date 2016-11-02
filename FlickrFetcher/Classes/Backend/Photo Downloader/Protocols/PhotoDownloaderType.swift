//
//  PhotoDownloaderType.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 02/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoDownloaderType: class {
    func operation(forIndexPath indexPath: IndexPath) -> Operation?
    func cancelOperation(atIndexPath indexPath: IndexPath)
    func startOperation(atIndexPath indexPath: IndexPath)
    func suspendAllOperations ()
    func resumeAllOperations ()
    
    func photo(forIndexPath indexPath: IndexPath) -> UIImage?
    
    func set(photos: [Photo])
}
