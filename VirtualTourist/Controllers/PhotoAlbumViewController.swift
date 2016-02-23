//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 13.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    private let photoAlbumView = PhotoAlbumView(frame: UIScreen.mainScreen().bounds)

    var pin: Pin

    private var fetchedPhotosCount: Int
    private var selectedPhotos = [Int]()
    private var allPhotoDidFetch: Bool {
        get {
            return fetchedPhotosCount == pin.photos?.count ?? 0
        }
    }

    override func loadView() {
        photoAlbumView.delegate = self
        view = photoAlbumView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPhotos()
    }

    private func fetchPhotos() {
        photoAlbumView.showPin(pin)
        photoAlbumView.state = .Fetching

        if pin.photos?.count == 0 {
            loadNewPhotos()
        } else {
            showAlbum()
        }
    }

    private func loadNewPhotos() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        VirtualTouristDataManager.instance.loadPhotosForPin(pin) {
            (flickrPhotos, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                if self.pin.hasPhotos {
                    self.showAlbum()
                }
            }
        }
    }

    private func showAlbum() {
        self.photoAlbumView.state = .New

        photoAlbumView.showAlbumForPin(pin, loadPhoto: {
            (fileName, completionHandler) -> () in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            VirtualTouristDataManager.instance.getPhoto(fileName) {
                (image, error) -> () in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    self.fetchedPhotosCount++
                    completionHandler(image)

                    if self.allPhotoDidFetch {
                        self.photoAlbumView.state = .New
                    }
                }
            }
        })
    }


    init(pin: Pin) {
        self.pin = pin

        fetchedPhotosCount = 0

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoAlbumViewController: PhotoAlbumViewDelegate {
    func photoAlbumViewDidTapOnPhotoWithIndex(index: Int) {
        if let index = selectedPhotos.indexOf({ $0 == index }) {
            selectedPhotos.removeAtIndex(index)
        } else {
            selectedPhotos.append(index)
        }

        photoAlbumView.state = selectedPhotos.count == 0 ? .New : .Remove
    }

    func photoAlbumViewDidTriggerAction() {
        // there are selected photo to remove
        if selectedPhotos.count > 0 {
            if let photosSet = pin.photos {
                let photos = photosSet.allObjects as! [Photo]
                for photoIndex in selectedPhotos {
                    let photo = photos[photoIndex]

                    VirtualTouristDataManager.instance.deletePhoto(photo)
                }

                photoAlbumView.removePhotosAtIndices(selectedPhotos)

                photoAlbumView.state = .New
            }
        }

        // new collection needs to be added
        if selectedPhotos.count == 0 {
            VirtualTouristDataManager.instance.deletePhotosForPin(pin)

            fetchPhotos()
        }

        selectedPhotos.removeAll()
    }
}
