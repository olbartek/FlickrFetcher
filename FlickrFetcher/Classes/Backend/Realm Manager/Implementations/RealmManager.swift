//
//  RealmManager.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager: RealmManagerType {
    
    func createAndSavePhoto(withUrl url: URL, imageData: Data) {
        let photo = ManagedPhoto()
        photo.url = url.absoluteString
        photo.imageData = NSData(data: imageData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(photo)
        }
    }
    
    func photoData(withUrl url: URL) -> Data? {
        let realm = try! Realm()
        let photo = realm.objects(ManagedPhoto.self).filter("url == %@", url.absoluteString)
        if let imageData = photo.first?.imageData {
            return imageData as Data
        } else {
            return nil
        }
    }
    
}
