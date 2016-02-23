//
//  MapView.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 13.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import UIKit
import MapKit

enum MapViewMode {
    case Add
    case Delete
}

protocol MapViewDelegate: class {
    func mapView(view: MapView, didAddLocation newLocation: CLLocationCoordinate2D)
    func mapView(view: MapView, didTappedWithLocation location: CLLocationCoordinate2D)
}

class MapView: UIView {
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        
        return mapView
    }()
    
    private var editingMode = MapViewMode.Add
    
    private lazy var longTapGestureRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer()
        recognizer.addTarget(self, action: "longTapDidOccure:")
        
        return recognizer
    }()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap Pins to Delete"
        label.backgroundColor = UIColor.redColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        
        return label
    }()
    
    weak var delegate: MapViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView.addGestureRecognizer(longTapGestureRecognizer)
        addSubview(mapView)
        addSubview(deleteLabel)
    }
    
    func switchToMode(mode: MapViewMode) {
        editingMode = mode
        
        setNeedsLayout()
    }
    
    func addAnnotationWithPin(pin: Pin) {
        mapView.addAnnotation(Annotation(pin: pin))
    }
    
    func addLocations(locations: [Pin]) {
        for location in locations {
            addAnnotationWithPin(location)
        }
     }
    
    func deletePin(pin: Pin) {
        mapView.removeAnnotation(Annotation(pin: pin))
    }
    
    func longTapDidOccure(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
        
        let touchLocation = sender.locationInView(mapView)
        let locationCoordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
      
        delegate?.mapView(self, didAddLocation: locationCoordinate)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mapView.frame = bounds
        
        var deleteLabelY: CGFloat = 0
        
        switch editingMode {
        case .Add:
            deleteLabelY = bounds.height
        case .Delete:
            deleteLabelY = bounds.height - 88
        }

        deleteLabel.frame = CGRect(x: 0, y: deleteLabelY, width: bounds.width, height: 88)
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        delegate?.mapView(self, didTappedWithLocation: (view.annotation?.coordinate)!)
    }
}
