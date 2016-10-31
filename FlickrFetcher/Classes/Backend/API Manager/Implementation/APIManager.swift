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
    
    func fetchPhotos(withTag tag: String, completion: @escaping ArrayResultBlock<APIPhoto>) {
        requestBuilder.GETRequest(withURL: urlBuilder.photosSearchUrl(withTag: tag)) { (result: ArrayResult<[String: Any]>) in
            switch result {
            case .Error(error: let error):
                completion(ArrayResult.Error(error: error))
            case .Success(result: let photosResult):
                let photos = photosResult.flatMap { APIPhoto(json: $0) }
                completion(ArrayResult.Success(result: photos))
            }
        }
    }
    
    
}
