//
//  APIManager.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

final class APIManager: APIManagerType {
    
    // MARK: Properties
    
    fileprivate let urlBuilder: URLBuilderType
    fileprivate let requestBuilder: RequestBuilderType
    
    // MARK: Initializers
    
    init(urlBuilder: URLBuilderType, requestBuilder: RequestBuilderType) {
        self.urlBuilder = urlBuilder
        self.requestBuilder = requestBuilder
    }
    
    // MARK: API
    
    func fetchPhotos(withTag tag: String, pageNumber: Int, completion: @escaping PaginationResultBlock<[APIPhoto]>) {
        requestBuilder.GETRequest(withURL: urlBuilder.photosSearchUrl(withTag: tag, pageNumber: pageNumber)) { (result: Result<[[String : Any]]>, pagination: APIPagination?) in
            switch result {
            case .error(let error):
                completion(Result.error(error), pagination)
            case .success(result: let photosResult):
                let photos = photosResult.flatMap { APIPhoto(json: $0) }
                completion(Result.success(photos), pagination)
            }
        }
    }
    
}
