//
//  APIError.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

enum APIError: Error {
    case wrongHttpCode(code: Int)
    case jsonSerializationFailed
    case noData
}
