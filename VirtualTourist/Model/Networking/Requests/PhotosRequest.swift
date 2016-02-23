//
//  PhotosRequest.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 16.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation

class PhotosRequest: Request {
    private let longitude: Double
    private let latitude: Double
    private let page: Int
    
    init(longitude: Double, latitude: Double, page: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.page = page
    }
    
    override func httpMethod() -> HTTPMethod {
        return .GET
    }
    
    override func queryString() -> String {
        return "?method=flickr.photos.search&format=json&nojsoncallback=1&per_page=30&lat=\(latitude)&lon=\(longitude)&page=\(page)"
    }
    
    
}
