//
//  YBStation+CoreDataProperties.swift
//  
//
//  Created by SK on 5/16/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension YBStation {

    @NSManaged var number: NSNumber?
    @NSManaged var nameCn: String?
    @NSManaged var availableBike: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var addressCn: String?
    @NSManaged var nameEn: String?
    @NSManaged var addressEn: String?
    @NSManaged var areaCn: String?
    @NSManaged var areaEn: String?

}
