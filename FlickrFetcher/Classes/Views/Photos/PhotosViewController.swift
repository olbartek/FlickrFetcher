//
//  PhotosViewController.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 31/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var apiManager: APIManagerType {
        let urlBuilder = URLBuilder()
        let requestBuilder = RequestBuilder()
        return APIManager(urlBuilder: urlBuilder, requestBuilder: requestBuilder)
    }
    
    // MARK: VC's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        apiManager.fetchPhotos(withTag: "dog") { result in
            switch result {
            case .Error(error: let error):
                print(error)
            case .Success(result: let photos):
                print(photos)
            }
        }
        
    }

}
