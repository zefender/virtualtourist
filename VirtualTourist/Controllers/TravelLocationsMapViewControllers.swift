//
//  TravelLocationsMapViewControllers.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 13.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import UIKit
import MapKit


class TravelLocationsMapViewControllers: UIViewController {
    private var locations: [Pin]?
    
    private let mapView = MapView(frame: UIScreen.mainScreen().bounds)
    
    private var editingMode: MapViewMode = .Add
    
    private lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "modeSwitchDidTapped:")
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "modeSwitchDidTapped:")
    }()
    
    
    override func loadView() {
        mapView.delegate = self
        
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Virtual Tourist"
        
        mapView.switchToMode(.Add)
        
        navigationItem.rightBarButtonItem = editButton
        
        if let locations = VirtualTouristDataManager.instance.getLocations() {
            mapView.addLocations(locations)
        }
    }
    
    func modeSwitchDidTapped(sender: AnyObject) {
        switch editingMode {
        case .Add:
            editingMode = .Delete
        case .Delete:
            editingMode = .Add
        }
        
        mapView.switchToMode(editingMode)
    }
}

extension TravelLocationsMapViewControllers: MapViewDelegate {
    func mapView(view: MapView, didAddLocation newLocation: CLLocationCoordinate2D) {
        // Store in core data
        let pin = VirtualTouristDataManager.instance.addPinWithLongitude(newLocation.longitude, latitude: newLocation.latitude)
        
        mapView.addAnnotationWithPin(pin)
    }
    
    func mapView(view: MapView, didTappedWithLocation location: CLLocationCoordinate2D) {
        switch editingMode {
        case .Add:
            if let pin = VirtualTouristDataManager.instance.pinWithLocation(location) {
                let controller = PhotoAlbumViewController(pin: pin)
                
                navigationController?.pushViewController(controller, animated: true)
            }
        case .Delete:
            if let deletedPin = VirtualTouristDataManager.instance.deletePinWithLocation(location) {
                mapView.deletePin(deletedPin)
            }
        }
    }
}