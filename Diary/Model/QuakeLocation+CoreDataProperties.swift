//
//  QuakeLocation+CoreDataProperties.swift
//  Diary
//
//  Created by Immanuel on 25/04/24.
//
//

import Foundation
import CoreData


extension QuakeLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuakeLocation> {
        return NSFetchRequest<QuakeLocation>(entityName: "QuakeLocation")
    }

    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var depth: NSNumber?
    @NSManaged public var quake: Quake?

}

extension QuakeLocation : Identifiable {

}
