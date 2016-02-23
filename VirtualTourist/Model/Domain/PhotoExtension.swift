//
// Created by Кузяев Максим on 10.02.16.
// Copyright (c) 2016 zefender. All rights reserved.
//

import Foundation

extension Photo {
    var filename: String {
        get {
            if let photoId = photoId, let secret = secret {
                return "\(photoId)_\(secret).jpg"
            }

            return ""
        }
    }

    var photoURL: String {
        get {
            if let farm = farm, let server = server {
                return "https://farm\(farm).staticflickr.com/\(server)/\(filename)"
            }

            return ""
        }
    }
}