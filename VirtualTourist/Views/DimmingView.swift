//
//  DimmingView.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 17.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import UIKit

class DimmingView: UIView {
    private let activityIndicator = UIActivityIndicatorView()
    
    var animating: Bool {
        didSet {
            if animating {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        animating = false
        
        super.init(frame: frame)

        addSubview(activityIndicator)
        
        backgroundColor = UIColor.purpleColor()
        layer.cornerRadius = 8
        alpha = 0.4
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
