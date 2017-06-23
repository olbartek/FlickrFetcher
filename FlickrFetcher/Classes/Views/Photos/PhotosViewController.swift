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
    
    fileprivate struct Constants {
        static var CellSize: CGSize = {
            let offset: CGFloat = 5.0
            let cellWidth = UIScreen.main.bounds.size.width / 2 - offset
            return CGSize(width: cellWidth, height: cellWidth)
        }()
        static let NextPageOffset = 1
    }
    
    // MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var apiManager: APIManagerType {
        let urlBuilder = URLBuilder()
        let requestBuilder = RequestBuilder()
        return APIManager(urlBuilder: urlBuilder, requestBuilder: requestBuilder)
    }
    lazy var photoDownloader: PhotoDownloaderType = {
        let realmManager = RealmManager()
        return PhotoDownloader(collectionView: self.collectionView, realmManager: realmManager)
    }()
    var photos = [Photo]() {
        didSet {
            photoDownloader.set(photos: self.photos)
        }
    }
    var currentTagToSearch = ""
    var currentPageToFetch = Constants.NextPageOffset
    var totalNumberOfPages = Int.max
    
    // MARK: VC's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Photos Searching
    
    func searchPhotos(withTag tag: String) {
        apiManager.fetchPhotos(withTag: tag, pageNumber: currentPageToFetch) { [weak self] result in
            guard let `self` = self else { return }
            switch result.0 {
            case .error(let error):
                print(error)
            case .success(let apiPhotos):
                let photos = apiPhotos.map { Photo(url: $0.standardPhotoUrl) }
                self.photos.append(contentsOf: photos)
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.spinner.stopAnimating()
                    self.noResultsLabel.isHidden = self.photos.count > 0
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
            photoDownloader.startOperation(atIndexPath: indexPath)
        case .downloaded:
            cell.spinner.stopAnimating()
            if let image = photoDownloader.photo(forIndexPath: indexPath) { cell.imageView.image = image }
        case .failed:
            cell.spinner.stopAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return Constants.CellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (indexPath.row + Constants.NextPageOffset) >= photos.count else { return }
        searchPhotos(withTag: currentTagToSearch)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        photoDownloader.cancelOperation(atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let text = searchBar.text else { return }
        let tag = text.stringTag
        guard tag.characters.count > 0 else { return }
        currentTagToSearch = tag
        currentPageToFetch = 1
        totalNumberOfPages = Int.max
        self.photos.removeAll()
        searchPhotos(withTag: tag)
        
        noResultsLabel.isHidden = true
        spinner.startAnimating()
    }
}
