
//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 16.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import Foundation
import UIKit

enum PhotoCollectionViewCellState {
    case Loading
    case ShowImage
}

class PhotoCollectionViewCell: UICollectionViewCell {
    var state: PhotoCollectionViewCellState {
        didSet {
            dimmingView.hidden = state == .ShowImage
            dimmingView.animating = state == .Loading
        }
    }
    
    override var selected: Bool {
        didSet {
            if state == .ShowImage {
                selectedView.alpha = selected ? 0.3 : 0
            }
        }
    }
    
    private let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 8
        
        return photo
    }()
    
    private let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 0
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private let dimmingView = DimmingView()
    
    var image: UIImage? {
        set {
            photoImageView.image = newValue
        }
        get {
            return photoImageView.image
        }
    }
    
    override init(frame: CGRect) {
        state = .Loading
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGrayColor()
        
        addSubview(photoImageView)
        addSubview(dimmingView)
        addSubview(selectedView)
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
        selected = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.frame = bounds
        dimmingView.frame = bounds
        selectedView.frame = bounds
    }
}
