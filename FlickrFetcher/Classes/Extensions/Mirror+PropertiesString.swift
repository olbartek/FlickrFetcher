//
//  Mirror+PropertiesString.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 24/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

extension Mirror {
    var propertiesString: String {
        get {
            var string = ""
            for case let (name?, value) in self.children {
                string = string + "\n\(name) = \(value)"
            }
            string = string + "\n"
            return string
        }
    }
}
