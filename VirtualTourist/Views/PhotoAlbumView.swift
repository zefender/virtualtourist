//
//  PhotoAlbumView.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 14.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import UIKit
import MapKit

enum PhotoAlbumViewState {
    case New
    case Remove
    case Empty
    case Fetching
}

protocol PhotoAlbumViewDelegate: class {
    func photoAlbumViewDidTriggerAction()

    func photoAlbumViewDidTapOnPhotoWithIndex(index: Int)
}


class PhotoAlbumView: UIView {
    weak var delegate: PhotoAlbumViewDelegate?

    var state: PhotoAlbumViewState = .New {
        didSet {
            switch state {
            case .New:
                barButton.title = "New Collection"
                barButton.enabled = true
                emptyLabel.hidden = true
                photosCollectionView.hidden = false
            case .Remove:
                barButton.title = "Remove Selected Pictures"
                barButton.enabled = true
                emptyLabel.hidden = true
                photosCollectionView.hidden = false
            case .Empty:
                barButton.title = "New Collection"
                barButton.enabled = true
                emptyLabel.hidden = false
                photosCollectionView.hidden = true
            case .Fetching:
                barButton.title = "New Collection"
                barButton.enabled = false
                emptyLabel.hidden = true
                photosCollectionView.hidden = false
            }
        }
    }

    private let mapView = MKMapView()
    private let cellId = "hotoCollectionViewCellId"
    private var loadPhoto: ((Photo, (UIImage?) -> ()) -> ())!
    private var pin: Pin?
    private lazy var barButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "New Collection", style: UIBarButtonItemStyle.Plain, target: self, action: "barButtonDidTapped:")

        return button
    }()


    private lazy var bottomToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.delegate = self

        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), self.barButton,
                         UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)]

        return toolBar
    }()

    private lazy var photosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.lightGrayColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        collectionView.allowsMultipleSelection = true
        collectionView.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)

        return collectionView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "This pin has no images"
        label.hidden = true
        label.textAlignment = .Center

        return label
    }()

    func barButtonDidTapped(sender: AnyObject) {
        delegate?.photoAlbumViewDidTriggerAction()
    }

    func showPin(pin: Pin) {
        self.pin = pin

        let annotation = Annotation(pin: pin)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: false)
    }

    func showAlbumForPin(pin: Pin, loadPhoto: (Photo, (UIImage?) -> ()) -> ()) {
        self.loadPhoto = loadPhoto

        photosCollectionView.reloadData()
    }


    func removePhotosAtIndices(indices: [Int]) {
        photosCollectionView.deleteItemsAtIndexPaths(indices.map {
            let indexPath = NSIndexPath(forRow: $0, inSection: 0)
            return indexPath
        })
    }


    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()

        addSubview(mapView)
        addSubview(photosCollectionView)
        addSubview(bottomToolBar)
        addSubview(emptyLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        mapView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 200)
        photosCollectionView.frame = CGRect(x: 0, y: mapView.bottom, width: bounds.width, height: bounds.height - mapView.height)
        bottomToolBar.frame = CGRect(x: 0, y: bounds.height - 44, width: bounds.width, height: 44)
        emptyLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - mapView.height)
        emptyLabel.center = photosCollectionView.center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoAlbumView: UIToolbarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .Bottom
    }
}


extension PhotoAlbumView: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
}

extension PhotoAlbumView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.photoAlbumViewDidTapOnPhotoWithIndex(indexPath.row)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.photoAlbumViewDidTapOnPhotoWithIndex(indexPath.row)
    }
}

extension PhotoAlbumView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.state = .Loading

        if let pin = pin {
            if let photosSet = pin.photos {
                let photos = photosSet.allObjects as! [Photo]

                let photo = photos[indexPath.row] as Photo

                if let loadPhoto = loadPhoto {
                    loadPhoto(photo) {
                        (image) in
                        if let image = image {
                            cell.image = image
                            cell.state = .ShowImage
                        }
                    }
                }
            }
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pin?.photos?.count ?? 0
    }
}

