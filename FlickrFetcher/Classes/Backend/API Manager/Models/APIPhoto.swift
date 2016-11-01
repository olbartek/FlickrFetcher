//
//  APIPhoto.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 24/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

enum APIPhotoState {
    case new, downloaded, failed
}

struct APIPhoto {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    var state: APIPhotoState = .new
    
    var standardPhotoUrl: URL {
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        return URL(string: urlString)!
    }
    var largeSquarePhotoUrl: URL {
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
        return URL(string: urlString)!
    }
    var mediumPhotoUrl: URL {
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_z.jpg"
        return URL(string: urlString)!
    }
    
}

extension APIPhoto: JSONDecodable {
    
    private struct APIKeys {
        static let Id = "id"
        static let Owner = "owner"
        static let Secret = "secret"
        static let Server = "server"
        static let Farm = "farm"
        static let Title = "title"
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json[APIKeys.Id] as? String,
            let owner = json[APIKeys.Owner] as? String,
            let secret = json[APIKeys.Secret] as? String,
            let server = json[APIKeys.Server] as? String,
            let farm = json[APIKeys.Farm] as? Int,
            let title = json[APIKeys.Title] as? String
        else { return nil }
        
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
    }
}

extension APIPhoto: CustomStringConvertible {
    var description: String {
        return Mirror(reflecting: self).propertiesString
    }
}
