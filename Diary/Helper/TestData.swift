//
//  TestData.swift
//  Diary
//
//  Created by Immanuel on 27/04/24.
//

import Foundation
import CoreData

struct TestData {
    
    static func insertTestData(context: NSManagedObjectContext, persistenceController: PersistenceController = PersistenceController.shared) async throws {
        if let fileURL = Bundle.main.url(forResource: "EarthquakeLargeDataPretty", withExtension: "json") {
            
            let data: Data = try Data(contentsOf: fileURL)
            
            let quakeData = try JSONDecoder().decode(GeoJSON.self, from: data)
            
            let backgroundContext = persistenceController.container.newBackgroundContext()
            
            try await backgroundContext.perform {
                
                for index in 1...70000 {
                    let user = User(context: backgroundContext)
                    user.username = "User\(index)"
                    user.password = "password\(index)"
                }
                
                try backgroundContext.save()
                 
                for quakeValue in quakeData.quakeList {
                    
                    let quake = Quake(context: backgroundContext)
                    quake.alert = quakeValue.quakeProperty.alert
                    quake.cdi = getNSNumber(for: quakeValue.quakeProperty.cdi)
                    quake.code = quakeValue.quakeProperty.code
                    quake.detail = quakeValue.quakeProperty.detail
                    quake.dmin = getNSNumber(for: quakeValue.quakeProperty.dmin)
                    quake.felt = getNSNumber(for: quakeValue.quakeProperty.felt)
                    quake.gap = getNSNumber(for: quakeValue.quakeProperty.gap)
                    quake.id = quakeValue.quakeProperty.id
                    quake.ids = quakeValue.quakeProperty.ids
                    quake.magnitude = getNSNumber(for: quakeValue.quakeProperty.magnitude)
                    quake.magType = quakeValue.quakeProperty.magType
                    quake.mmi = getNSNumber(for: quakeValue.quakeProperty.mmi)
                    quake.nst = getNSNumber(for: quakeValue.quakeProperty.nst)
                    quake.place = quakeValue.quakeProperty.place
                    quake.sig = getNSNumber(for: quakeValue.quakeProperty.sig)
                    quake.status = quakeValue.quakeProperty.status
                    quake.time = quakeValue.quakeProperty.time
                    quake.title = quakeValue.quakeProperty.title
                    quake.tsunami = getNSNumber(for: quakeValue.quakeProperty.tsunami)
                    quake.type = quakeValue.quakeProperty.type
                    quake.types = quakeValue.quakeProperty.types
                    quake.tz = getNSNumber(for: quakeValue.quakeProperty.tz)
                    quake.updatedDate = quakeValue.quakeProperty.updatedDate
                    quake.url = quakeValue.quakeProperty.url
                    
                    let quakeLocation = QuakeLocation(context: backgroundContext)
                    quakeLocation.latitude = getNSNumber(for: quakeValue.quakeGeometry.latitude)
                    quakeLocation.longitude = getNSNumber(for: quakeValue.quakeGeometry.longitude)
                    quakeLocation.depth = getNSNumber(for: quakeValue.quakeGeometry.depth)
                    quakeLocation.quake = quake
                    
                }
                
                try backgroundContext.save()
                try context.save()
                
            }
        }
    }
    
    static func previewEarthquakeTestData(context: NSManagedObjectContext, limit: Int) throws {
        if let fileURL = Bundle.main.url(forResource: "EarthquakeLargeDataPretty", withExtension: "json") {
            
            let data: Data = try Data(contentsOf: fileURL)
            
            let quakeData = try JSONDecoder().decode(GeoJSON.self, from: data)
            
            for (index, quakeValue) in quakeData.quakeList.enumerated() {
                
                if index >= limit {
                    break
                }
                
                let quake = Quake(context: context)
                quake.alert = quakeValue.quakeProperty.alert
                quake.cdi = getNSNumber(for: quakeValue.quakeProperty.cdi)
                quake.code = quakeValue.quakeProperty.code
                quake.detail = quakeValue.quakeProperty.detail
                quake.dmin = getNSNumber(for: quakeValue.quakeProperty.dmin)
                quake.felt = getNSNumber(for: quakeValue.quakeProperty.felt)
                quake.gap = getNSNumber(for: quakeValue.quakeProperty.gap)
                quake.id = quakeValue.quakeProperty.id
                quake.ids = quakeValue.quakeProperty.ids
                quake.magnitude = getNSNumber(for: quakeValue.quakeProperty.magnitude)
                quake.magType = quakeValue.quakeProperty.magType
                quake.mmi = getNSNumber(for: quakeValue.quakeProperty.mmi)
                quake.nst = getNSNumber(for: quakeValue.quakeProperty.nst)
                quake.place = quakeValue.quakeProperty.place
                quake.sig = getNSNumber(for: quakeValue.quakeProperty.sig)
                quake.status = quakeValue.quakeProperty.status
                quake.time = quakeValue.quakeProperty.time
                quake.title = quakeValue.quakeProperty.title
                quake.tsunami = getNSNumber(for: quakeValue.quakeProperty.tsunami)
                quake.type = quakeValue.quakeProperty.type
                quake.types = quakeValue.quakeProperty.types
                quake.tz = getNSNumber(for: quakeValue.quakeProperty.tz)
                quake.updatedDate = quakeValue.quakeProperty.updatedDate
                quake.url = quakeValue.quakeProperty.url
                
                let quakeLocation = QuakeLocation(context: context)
                quakeLocation.latitude = getNSNumber(for: quakeValue.quakeGeometry.latitude)
                quakeLocation.longitude = getNSNumber(for: quakeValue.quakeGeometry.longitude)
                quakeLocation.depth = getNSNumber(for: quakeValue.quakeGeometry.depth)
                quakeLocation.quake = quake
                
            }
        }
    }
    
    // TODO: check how to batch insert request along with relationship attribute
    private static func newBatchInsertRequest(with data: [QuakeData]) -> NSBatchInsertRequest {
        
        var index = 0
        let total = data.count
        
        let batchInsertRequest = NSBatchInsertRequest(entity: Quake.entity(), dictionaryHandler: { dictionary in
            guard index < total else {
                return true
            }
            dictionary.addEntries(from: data[index].dictionary)
            index += 1
            return false
        })
        return batchInsertRequest
        
    }
    
    private static func getNSNumber<T>(for value: T?) -> NSNumber? {
        if let int16Value = value as? Int16 {
            return NSNumber(value: int16Value)
        } else if let doubleValue = value as? Double {
            return NSNumber(value: doubleValue)
        }
        return nil
    }
    
}
