//
//  JSONDecodable.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 24/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    init?(json: [String: Any])
}
