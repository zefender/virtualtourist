//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 13.01.16.
//  Copyright © 2016 zefender. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window : UIWindow? = {
        return UIWindow(frame: UIScreen.mainScreen().bounds)
    }()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.rootViewController = UINavigationController(rootViewController: TravelLocationsMapViewControllers())
        window?.makeKeyAndVisible()
        
        return true
    }
}

