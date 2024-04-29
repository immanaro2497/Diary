//
//  Quake+CoreDataProperties.swift
//  Diary
//
//  Created by Immanuel on 25/04/24.
//
//

import Foundation
import CoreData
import SwiftUI


extension Quake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quake> {
        return NSFetchRequest<Quake>(entityName: "Quake")
    }

    @NSManaged public var place: String?
    @NSManaged public var tz: NSNumber?
    @NSManaged public var time: Date?
    @NSManaged public var status: String?
    @NSManaged public var url: URL?
    @NSManaged public var alert: String?
    @NSManaged public var tsunami: NSNumber?
    @NSManaged public var sig: NSNumber?
    @NSManaged public var code: String?
    @NSManaged public var ids: String?
    @NSManaged public var dmin: NSNumber?
    @NSManaged public var gap: NSNumber?
    @NSManaged public var magType: String?
    @NSManaged public var title: String?
    @NSManaged public var nst: NSNumber?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var magnitude: NSNumber?
    @NSManaged public var types: String?
    @NSManaged public var type: String?
    @NSManaged public var cdi: NSNumber?
    @NSManaged public var felt: NSNumber?
    @NSManaged public var detail: URL?
    @NSManaged public var mmi: NSNumber?
    @NSManaged public var id: String?
    @NSManaged public var quakeLocation: QuakeLocation?

}

extension Quake : Identifiable {

}

extension Quake {
    
    var getQuakeIntensityColor: Color {
        switch magnitude!.doubleValue {
        case 0..<1:
            return Color.green
        case 1..<2:
            return Color.yellow
        case 2..<3:
            return Color.orange
        case 3..<5:
            return Color.red
        case 5..<Double.greatestFiniteMagnitude:
            return Color(red: 0.8, green: 0.2, blue: 0.7)
        default:
            return Color.black
        }
    }
    
}

enum QuakeStatus: String {
    case automatic
    case reviewed
    case deleted
}
