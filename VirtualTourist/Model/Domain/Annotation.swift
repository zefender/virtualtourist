
//
//  Annotation.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 17.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    private let privateCoordinate: CLLocationCoordinate2D
    
    @objc var title: String?
    @objc var subtitle: String?

    @objc var coordinate: CLLocationCoordinate2D {
        get {
            return privateCoordinate
        }
    }
    
    init(pin: Pin) {
        privateCoordinate = CLLocationCoordinate2D(latitude: pin.latitude?.doubleValue ?? 0, longitude: pin.longitude?.doubleValue ?? 0)
    }
}
