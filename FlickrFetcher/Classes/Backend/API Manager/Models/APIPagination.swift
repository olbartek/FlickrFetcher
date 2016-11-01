//
//  APIPagination.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

struct APIPagination {
    let currentPage: Int
    let numberOfPages: Int
    let resultsPerPage: Int
    
    init(page: Int, pages: Int, perPage: Int) {
        currentPage = page
        numberOfPages = pages
        resultsPerPage = perPage
    }
}
