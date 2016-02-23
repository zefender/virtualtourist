//
//  ImageRequest.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 16.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation

class ImageRequest: Request {
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    override func httpMethod() -> HTTPMethod {
        return .GET
    }
    
    override func queryString() -> String {
        return "/\(photo.photoURL)"
    }
    
}