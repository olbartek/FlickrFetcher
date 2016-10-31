//
//  JSONEncodable.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 27/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

protocol JSONEncodable {
    func toJSON() -> [String: Any]
}
