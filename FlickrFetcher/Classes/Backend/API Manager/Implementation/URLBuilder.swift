//
//  URLBuilder.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

final class URLBuilder: URLBuilderType {
    
    // MARK: Constants
    
    fileprivate struct Flickr {
        static let APIURL = "https://api.flickr.com/services/rest/"
        static let APIKey = "2cec5a1c921ef31076b0fc8607dd31b3"
        static let APISecret = "4b004da11ae257b0"
        static let ResultsPerPage = 10
        
        struct Method {
            static let PhotosSearch = "flickr.photos.search"
            static let PhotosGetRecent = "flickr.photos.getRecent"
        }
    }
    
    // MARK: URLs
    
    func photosSearchUrl(withTag tag: String, pageNumber: Int) -> URL {
        let urlString = Flickr.APIURL + "?method=\(Flickr.Method.PhotosSearch)&api_key=\(Flickr.APIKey)&tags=\(tag)&per_page=\(Flickr.ResultsPerPage)&page=\(pageNumber)&format=json&nojsoncallback=1"
        return URL(string: urlString)!
    }
    
    func photosGetRecentUrl(withTag tag: String, pageNumber: Int) -> URL {
        let urlString = Flickr.APIURL + "?method=\(Flickr.Method.PhotosGetRecent)&api_key=\(Flickr.APIKey)&tags=\(tag)&per_page=\(Flickr.ResultsPerPage)&page=\(pageNumber)&format=json&nojsoncallback=1"
        return URL(string: urlString)!
    }
    
}
