//
//  PhotosParser.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 24.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation

class PhotosParser: Parser {
    override func scanObject(parsedJson: [String : AnyObject]) -> Any? {
        if let results = parsedJson["photos"] as? NSDictionary {
            var perPage = 0
            var pages = 0
            var total = 0
            var page = 0
            
            if let perPageValue = results["perpage"] as? Int {
                perPage = perPageValue
            }
            
            if let pagesValue = results["pages"] as? Int {
                pages = pagesValue
            }
            
            if let totalValue = results["total"] as? String {
                total = Int(totalValue)!
            }
            
            if let pageValue = results["page"] as? Int {
                page = pageValue
            }
            
            var flickrPhotos = FlickrPhotos(perPage: perPage, pages: pages, total: total, page: page, photos: nil)
            
            if let photos = results["photo"] as? [[String: AnyObject]] {
                if photos.count > 0 {
                    var photoCollection = [FlickrPhoto]()
                    
                    for photo in photos {
                        let flickrPhoto = FlickrPhoto(title: String(photo["title"]!), photoId: String(photo["id"]!), server: String(photo["server"]!), secret: String(photo["secret"]!), farm: Int(photo["farm"] as? Int ?? 0))
                        
                        photoCollection.append(flickrPhoto)
                    }
                    
                    flickrPhotos.photos = photoCollection
                }
            }
            
            return flickrPhotos
        }
        
        return nil
    }
}