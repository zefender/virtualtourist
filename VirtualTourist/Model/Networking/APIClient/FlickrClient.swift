//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 16.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation

class FlickrClient {
    private let apiKey = "11a8680977429f9f817c6c6a4b5ba0ec"
    private let baseUrl = "https://api.flickr.com/services/rest/"
    
    func sendRequest(request: Request, completionHandler: (NSData?, NSError?) -> Void) {
        var query = request.queryString()
        query.appendContentsOf("&api_key=\(apiKey)")
        
        let urlString = "\(baseUrl)/\(query)"
        let httpRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        httpRequest.HTTPMethod = request.httpMethod().rawValue        

        httpRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        
        print(httpRequest)
        
        let task = session.dataTaskWithRequest(httpRequest) { data, response, error in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(data, error)
            })
        }
        
        task.resume()
    }
    
    func loadWithUrl(url: NSURL, completionHandler: (NSData?, NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in
            let httpResponse = response as! NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(data, error)
                })
            }
        })
        
        task.resume()
    }

}
