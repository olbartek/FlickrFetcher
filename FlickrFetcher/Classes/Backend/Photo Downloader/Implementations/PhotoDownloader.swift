//
//  PhotoDownloader.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation
import UIKit

final class PhotoDownloader: PhotoDownloaderType {
    
    // MARK: Properties
    
    private lazy var downloadsInProgress = [IndexPath:Operation]()
    private lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
    
    private weak var collectionView: UICollectionView?
    private let realmManager: RealmManagerType
    private var photos = [Photo]()
    
    // MARK: Initialization
    
    init(collectionView: UICollectionView, realmManager: RealmManagerType) {
        self.collectionView = collectionView
        self.realmManager = realmManager
    }
    
    func set(photos: [Photo]) {
        self.photos = photos
    }
    
    // MARK: Download Operations
    
    private func startDownload(photo: Photo, forIndexPath indexPath: IndexPath) {
        if let _ = downloadsInProgress[indexPath] { return }
        
        let photoDownloadOperation = PhotoDownload(photo: photo, realmManager: realmManager)

        photoDownloadOperation.completionBlock = { [weak self, weak photoDownloadOperation] in
            guard let `self` = self, let photoDownloadOperation = photoDownloadOperation else { return }
            if photoDownloadOperation.isCancelled { return }
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView?.performBatchUpdates({ [weak self] in
                    guard let `self` = self else { return }
                    self.collectionView?.reloadItems(at: [indexPath])
                })
            }
        }
        downloadsInProgress[indexPath] = photoDownloadOperation
        downloadQueue.addOperation(photoDownloadOperation)
    }
    
    // MARK: Operations
    
    func operation(forIndexPath indexPath: IndexPath) -> Operation? {
        return downloadsInProgress[indexPath]
    }
    
    func cancelOperation(atIndexPath indexPath: IndexPath) {
        if let pendingDownload = downloadsInProgress[indexPath] {
            pendingDownload.cancel()
            downloadsInProgress.removeValue(forKey: indexPath)
        }
    }
    
    func startOperation(atIndexPath indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        startDownload(photo: photo, forIndexPath: indexPath)
    }
    
    func suspendAllOperations () {
        downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        downloadQueue.isSuspended = false
    }
    
    // MARK: Photos
    
    func photo(forIndexPath indexPath: IndexPath) -> UIImage? {
        let photoUrl = photos[indexPath.row].url
        let imageData = realmManager.photoData(withUrl: photoUrl)
        if let imageData = imageData {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
    
}
