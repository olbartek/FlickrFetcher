//
//  APIManagerType.swift
//  Garage
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

protocol APIManagerType: class {
    
    func fetchPhotos(withTag tag: String, completion: @escaping ArrayResultBlock<APIPhoto>)
}
