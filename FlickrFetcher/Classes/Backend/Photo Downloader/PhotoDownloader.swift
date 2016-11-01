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
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    weak var collectionView: UICollectionView?
    
    // MARK: Initialization
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    // MARK: Download Operations
    
    func startDownload(photo: Photo, forIndexPath indexPath: IndexPath) {
        
        if let _ = downloadsInProgress[indexPath] { return }
        
        let photoDownloadOperation = PhotoDownload(photo: photo)

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
    
    // MARK: Operation
    
    func operation(forIndexPath indexPath: IndexPath) -> Operation? {
        return downloadsInProgress[indexPath]
    }
    
}
