//
//  PhotoDownloader.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 01/11/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation
import UIKit

class PhotoDownloader {
    
    // MARK: Properties
    
    private lazy var downloadsInProgress = [IndexPath:Operation]()
    private lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        //queue.maxConcurrentOperationCount = 1
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
    
    func startDownload(photo: Photo, forIndexPath indexPath: IndexPath) {
        
        if let _ = downloadsInProgress[indexPath] { return }
        
        let photoDownloadOperation = PhotoDownload(photo: photo, realmManager: realmManager)

        photoDownloadOperation.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            if photoDownloadOperation.isCancelled { return }
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView?.performBatchUpdates({
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
    func suspendAllOperations () {
        downloadQueue.isSuspended = true
    }
    func resumeAllOperations () {
        downloadQueue.isSuspended = false
    }
    func loadPhotosForOnscreenCells() {
        if let pathsArray = collectionView?.indexPathsForVisibleItems {
            
            let allPendingOperations = Set(downloadsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                downloadsInProgress.removeValue(forKey: indexPath)
            }
            
            for indexPath in toBeStarted {
                let photo = photos[indexPath.row]
                startDownload(photo: photo, forIndexPath: indexPath)
            }
        }
    }
    
}
