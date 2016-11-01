//
//  ManagedPhoto.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation
import RealmSwift

class ManagedPhoto: Object {
    dynamic var url = ""
    dynamic var imageData = NSData()
}
