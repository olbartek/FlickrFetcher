//
//  Result.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

typealias ResultBlock<T>            = (Result<T>) -> ()
typealias PaginationResultBlock<T>  = (Result<T>, APIPagination?) -> ()
