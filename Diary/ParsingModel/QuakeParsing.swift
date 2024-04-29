//
//  QuakeParsing.swift
//  Diary
//
//  Created by Immanuel on 25/04/24.
//

import Foundation

//struct GeoJSON: Codable {
//    let features: [Feature]
//}
//
//struct Feature: Codable {
//    let properties: QuakeData
//    let id: String
//    let geometry: QuakeGeometry
//}
//
//struct QuakeGeometry: Codable {
//    let coordinates: [Double]
//}

struct GeoJSON: Decodable {
    
    private(set) var quakeList: [QuakeData] = []
    
    enum GeoJSONCodingKeys: String, CodingKey {
        case features
    }
    
    enum FeatureCodingKeys: String, CodingKey {
        case properties
        case geometry
    }
    
    enum GeometryCodingKeys: String, CodingKey {
        case coordinates
    }
    
    init(from decoder: Decoder) throws {
        let geoJSONContainer = try decoder.container(keyedBy: GeoJSONCodingKeys.self)
        var featuresContainer = try geoJSONContainer.nestedUnkeyedContainer(forKey: .features)
        
        while !featuresContainer.isAtEnd {
            let featureContainer = try featuresContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)
            
            let quakeProperty = try featureContainer.decode(QuakeProperty.self, forKey: .properties)
            
            let geometryContainer = try featureContainer.nestedContainer(keyedBy: GeometryCodingKeys.self, forKey: .geometry)
            var coordinatesContainer = try geometryContainer.nestedUnkeyedContainer(forKey: .coordinates)
            
            var latitude: Double?
            var longitude: Double?
            var depth: Double?
            while !coordinatesContainer.isAtEnd {
                let value =
                try coordinatesContainer.decode(Double.self)
                switch coordinatesContainer.currentIndex {
                case 1:
                    longitude = value
                case 2:
                    latitude = value
                case 3:
                    depth = value
                default:
                    continue
                }
            }
            
            quakeList.append(
                QuakeData(
                    quakeProperty: quakeProperty,
                    quakeGeometry: QuakeGeometry(latitude: latitude, longitude: longitude, depth: depth)
                )
            )
        }
        
    }
}

struct QuakeData {
    let quakeProperty: QuakeProperty
    let quakeGeometry: QuakeGeometry
    
    var dictionary: [String: Any] {
        [
            "alert": quakeProperty.alert as Any,
            "cdi": quakeProperty.cdi as Any,
            "code": quakeProperty.code as Any,
            "detail": quakeProperty.detail as Any,
            "dmin": quakeProperty.dmin as Any,
            "felt": quakeProperty.felt as Any,
            "gap": quakeProperty.gap as Any,
            "id": quakeProperty.id as Any,
            "ids": quakeProperty.ids as Any,
            "magnitude": quakeProperty.magnitude as Any,
            "magType": quakeProperty.magType as Any,
            "mmi": quakeProperty.mmi as Any,
            "nst": quakeProperty.nst as Any,
            "place": quakeProperty.place as Any,
            "sig": quakeProperty.sig as Any,
            "status": quakeProperty.status as Any,
            "time": quakeProperty.time as Any,
            "title": quakeProperty.title as Any,
            "tsunami": quakeProperty.tsunami as Any,
            "type": quakeProperty.type as Any,
            "types": quakeProperty.types as Any,
            "tz": quakeProperty.tz as Any,
            "updatedDate": quakeProperty.updatedDate as Any,
            "url": quakeProperty.url as Any,
//            "quakeLocation": [
//                "latitude": quakeGeometry.latitude,
//                "longitude": quakeGeometry.longitude,
//                "depth": quakeGeometry.depth
//            ]
        ]
    }
}

struct QuakeProperty: Codable {
    
    // TODO: fix date
    let alert: String?
    let cdi: Double?
    let code: String?
    let detail: URL?
    let dmin: Double?
    let felt: Int?
    let gap: Double?
    let id: String?
    let ids: String?
    let magnitude: Double?
    let magType: String?
    let mmi: Double?
    let nst: Int?
    let place: String?
    let sig: Int?
    let status: String?
    let time: Date?
    let title: String?
    let tsunami: Int?
    let type: String?
    let types: String?
    let tz: Int?
    let updatedDate: Date?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case alert
        case cdi
        case code
        case detail
        case dmin
        case felt
        case gap
        case id
        case ids
        case magnitude = "mag"
        case magType
        case mmi
        case nst
        case place
        case sig
        case status
        case time
        case title
        case tsunami
        case type
        case types
        case tz
        case updatedDate = "updated"
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alert = try container.decodeIfPresent(String.self, forKey: .alert)
        self.cdi = try container.decodeIfPresent(Double.self, forKey: .cdi)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.detail = try container.decodeIfPresent(URL.self, forKey: .detail)
        self.dmin = try container.decodeIfPresent(Double.self, forKey: .dmin)
        self.felt = try container.decodeIfPresent(Int.self, forKey: .felt)
        self.gap = try container.decodeIfPresent(Double.self, forKey: .gap)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.ids = try container.decodeIfPresent(String.self, forKey: .ids)
        self.magnitude = try container.decodeIfPresent(Double.self, forKey: .magnitude)
        self.magType = try container.decodeIfPresent(String.self, forKey: .magType)
        self.mmi = try container.decodeIfPresent(Double.self, forKey: .mmi)
        self.nst = try container.decodeIfPresent(Int.self, forKey: .nst)
        self.place = try container.decodeIfPresent(String.self, forKey: .place)
        self.sig = try container.decodeIfPresent(Int.self, forKey: .sig)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.time = try container.decodeIfDatePresent(forKey: .time)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.tsunami = try container.decodeIfPresent(Int.self, forKey: .tsunami)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.types = try container.decodeIfPresent(String.self, forKey: .types)
        self.tz = try container.decodeIfPresent(Int.self, forKey: .tz)
        self.updatedDate = try container.decodeIfDatePresent(forKey: .updatedDate)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
    }
    
}

struct QuakeGeometry {
    let latitude: Double?
    let longitude: Double?
    let depth: Double?
}

extension KeyedDecodingContainer {
    
    public func decodeIfDatePresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Date? {
        if let time = try decodeIfPresent(Double.self, forKey: key) {
            return Date(timeIntervalSince1970: TimeInterval(time) / 1000)
        }
        return nil
    }
    
}
