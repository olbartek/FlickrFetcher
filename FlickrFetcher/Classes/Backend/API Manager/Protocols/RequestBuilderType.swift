//
//  RequestBuilderType.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

protocol RequestBuilderType {
    
    func GETRequest(withURL url: URL, completion: @escaping PaginationResultBlock<[String: Any]>)
    func GETRequest(withURL url: URL, completion: @escaping PaginationResultBlock<[[String: Any]]>)
    
}
