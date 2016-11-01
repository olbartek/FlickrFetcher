//
//  PhotosViewController.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 31/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    // MARK: Constants
    
    fileprivate lazy var CellSize: CGSize = {
        let offset: CGFloat = 5.0
        let cellWidth = UIScreen.main.bounds.size.width / 2 - offset
        return CGSize(width: cellWidth, height: cellWidth)
    }()
    
    // MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var apiManager: APIManagerType {
        let urlBuilder = URLBuilder()
        let requestBuilder = RequestBuilder()
        return APIManager(urlBuilder: urlBuilder, requestBuilder: requestBuilder)
    }
    lazy var photoDownloader: PhotoDownloader = {
        return PhotoDownloader(collectionView: self.collectionView)
    }()
    var photos = [Photo]()
    
    // MARK: VC's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        apiManager.fetchPhotos(withTag: "dog") { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .Error(error: let error):
                print(error)
            case .Success(result: let photos):
                self.photos = photos.map { Photo(url: $0.standardPhotoUrl) }
                self.collectionView.reloadData()
            }
        }
        
    }

}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: PhotoCollectionViewCell.self, indexPath: indexPath)
        let photo = photos[indexPath.row]
        if let image = photo.image { cell.imageView.image = image }
        switch photo.state {
        case .new:
            cell.spinner.startAnimating()
            photoDownloader.startDownload(photo: photo, forIndexPath: indexPath)
        case .downloaded:
            cell.spinner.stopAnimating()
        case .failed:
            cell.spinner.stopAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CellSize
    }
    
}
