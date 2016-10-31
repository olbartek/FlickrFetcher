//
//  URLBuilderType.swift
//  infoBTC
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

protocol URLBuilderType: class {
    
    func photosSearchUrl(withTag tag: String) -> URL
    func photosGetRecentUrl(withTag tag: String) -> URL
}
