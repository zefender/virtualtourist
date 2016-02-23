//
//  VirtualTouristDataManager.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 16.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation
import MapKit

class VirtualTouristDataManager {
    static let instance = VirtualTouristDataManager()

    private var locations: [Pin]?

    private let coreDataSource = CoreDataDataSource()
    private let apiClient = FlickrClient()
    private let imageStorage = ImageDataManager()

    func getPhoto(photo: Photo, completionHandler: (UIImage?, NSError?) -> ()) {
        // try to get photo from local storage
        if let localImage = imageStorage.fetchImageWithFileName(photo.filename) {
            completionHandler(localImage, nil)
        } else {
            // load from api if not existst in local storage
            if let url = NSURL(string: photo.photoURL) {
                apiClient.loadWithUrl(url, completionHandler: {
                    (data, error) -> Void in
                    var image: UIImage? = nil

                    if let data = data {
                        image = UIImage(data: data)

                        // Store to local store
                        self.imageStorage.storeImageData(data, withFileName: photo.filename)
                    }

                    completionHandler(image, error)
                })
            }
        }
    }

    func deletePhotosForPin(pin: Pin) {
        coreDataSource.deletePhotos(pin)
    }

    func deletePhoto(photo: Photo) {
        imageStorage.deletePhoto(photo.filename)
        coreDataSource.deletePhoto(photo)
    }

    func getLocations() -> [Pin]? {
        locations = coreDataSource.getPins()
        return locations
    }

    func addPinWithLongitude(longitude: Double, latitude: Double) -> Pin {
        let pin = coreDataSource.addPinWithLongitude(longitude, latitude: latitude)
        locations?.append(pin)

        return pin
    }

    func deletePinWithLocation(location: CLLocationCoordinate2D) -> Pin? {
        if let locations = locations {
            for foundedLocation in locations where foundedLocation.longitude == location.longitude && foundedLocation.latitude == location.latitude {
                // first delete all local images for pin
                if let photoSet = foundedLocation.photos {
                    let photos = photoSet.allObjects as! [Photo]
                    for photo in photos {
                         imageStorage.deletePhoto(photo.filename)
                    }
                }

                coreDataSource.deletePin(foundedLocation)
                return foundedLocation
            }
        }

        return nil
    }

    func pinWithLocation(location: CLLocationCoordinate2D) -> Pin? {
        if let locations = locations {
            for foundedLocation in locations
            where foundedLocation.longitude == location.longitude && foundedLocation.latitude == location.latitude {
                return foundedLocation
            }
        }

        return nil
    }

    func loadPhotosForPin(pin: Pin, completionHandler: (FlickrPhotos?, NSError?) -> Void) {
        // randomize page
        let diceRoll = Int(arc4random_uniform(10))

        let request = PhotosRequest(longitude: pin.lon, latitude: pin.lat, page: diceRoll)

        apiClient.sendRequest(request) {
            (data, error) -> Void in
            var flickrPhotos: FlickrPhotos? = nil

            if let data = data {
                flickrPhotos = PhotosParser(data: data).parse() as? FlickrPhotos
            }

            if let photos = flickrPhotos?.photos {
                for flickrPhoto in photos {
                    self.coreDataSource.addPhoto(flickrPhoto, forPin: pin)
                }
            }

            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                completionHandler(flickrPhotos, error)
            })
        }
    }

    private init() {
    }
}
