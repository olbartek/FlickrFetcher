//
//  Result.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

enum Result<T> {
    case Error(error : Error)
    case Success(result : T)
}

enum ArrayResult<T> {
    case Error(error : Error)
    case Success(result : [T])
}

typealias ResultBlock<T>        = (Result<T>) -> ()
typealias ArrayResultBlock<T>   = (ArrayResult<T>) -> ()
