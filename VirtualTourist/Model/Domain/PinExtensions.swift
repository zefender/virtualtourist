//
//  PinExtensions.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 24.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation

extension Pin {
    var lon: Double {
        get {
            return longitude?.doubleValue ?? 0
        }
    }
    
    var lat: Double {
        get {
            return latitude?.doubleValue ?? 0
        }
    }

    var hasPhotos: Bool {
        get {
            if let photos = self.photos {
                return photos.count != 0
            }

            return false
        }
    }
}
