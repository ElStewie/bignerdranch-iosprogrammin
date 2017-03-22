//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Hisham Abraham on 3/20/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var dateTaken: NSDate?
    @NSManaged public var remoteURL: NSObject?

}
