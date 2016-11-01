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
    
    fileprivate lazy var cellSize: CGSize = {
        let offset: CGFloat = 5.0
        let cellWidth = UIScreen.main.bounds.size.width / 2 - offset
        return CGSize(width: cellWidth, height: cellWidth)
    }()
    
    // MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var apiManager: APIManagerType {
        let urlBuilder = URLBuilder()
        let requestBuilder = RequestBuilder()
        return APIManager(urlBuilder: urlBuilder, requestBuilder: requestBuilder)
    }
    lazy var photoDownloader: PhotoDownloader = {
        let realmManager = RealmManager()
        return PhotoDownloader(collectionView: self.collectionView, realmManager: realmManager)
    }()
    var photos = [Photo]() {
        didSet {
            photoDownloader.set(photos: self.photos)
        }
    }
    var currentTextToSearch = ""
    var currentPageToFetch = 1
    var totalNumberOfPages = Int.max
    
    // MARK: VC's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Photos Searching
    
    func searchPhotos(withText text: String) {
        apiManager.fetchPhotos(withTag: text.stringTag, pageNumber: currentPageToFetch) { [weak self] result in
            guard let `self` = self else { return }
            switch result.0 {
            case .Error(error: let error):
                print(error)
            case .Success(result: let apiPhotos):
                let photos = apiPhotos.map { Photo(url: $0.standardPhotoUrl) }
                self.photos.append(contentsOf: photos)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
            if let pagination = result.1 {
                if self.currentPageToFetch <= self.totalNumberOfPages {
                    self.currentPageToFetch = pagination.currentPage + 1
                    self.totalNumberOfPages = pagination.numberOfPages
                }
                
            }
        }
    }

}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: PhotoCollectionViewCell.self, indexPath: indexPath)
        let photo = photos[indexPath.row]
        switch photo.state {
        case .new:
            cell.spinner.startAnimating()
            if (!collectionView.isDragging && !collectionView.isDecelerating) {
                photoDownloader.startDownload(photo: photo, forIndexPath: indexPath)
            }
        case .downloaded:
            cell.spinner.stopAnimating()
            if let image = photo.image { cell.imageView.image = image }
        case .failed:
            cell.spinner.stopAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        currentTextToSearch = text
        currentPageToFetch = 1
        totalNumberOfPages = Int.max
        self.photos.removeAll()
        searchPhotos(withText: text)
        
        view.endEditing(true)
        spinner.startAnimating()
    }
}

extension PhotosViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        photoDownloader.suspendAllOperations()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            photoDownloader.loadPhotosForOnscreenCells()
            photoDownloader.resumeAllOperations()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        photoDownloader.loadPhotosForOnscreenCells()
        photoDownloader.resumeAllOperations()
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge >= self.collectionView.collectionViewLayout.collectionViewContentSize.height) {
            searchPhotos(withText: currentTextToSearch)
        }
    }
}
