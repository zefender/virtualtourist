//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Кузяев Максим on 13.02.16.
//  Copyright © 2016 zefender. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var farm: NSNumber?
    @NSManaged var identifier: String?
    @NSManaged var secret: String?
    @NSManaged var server: String?
    @NSManaged var title: String?
    @NSManaged var photoId: String?
    @NSManaged var pin: Pin?

}
