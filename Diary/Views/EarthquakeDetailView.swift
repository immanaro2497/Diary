//
//  EarthquakeDetailView.swift
//  Diary
//
//  Created by Immanuel on 28/04/24.
//

import SwiftUI
import CoreData
import MapKit

struct EarthquakeDetailView: View {
    let quake: Quake
    
    var body: some View {
        VStack {
            if let latitude = quake.quakeLocation?.latitude?.doubleValue,
               let longitude = quake.quakeLocation?.longitude?.doubleValue {
                Map(position: .constant(.region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                    )
                )))
                    .frame(maxWidth: .greatestFiniteMagnitude)
                    .aspectRatio(2, contentMode: .fit)
            }
            Text(quake.title ?? "title")
            Text(quake.place ?? "plac")
        }
    }
}

#Preview {
    let context = PersistenceController.earthquakeTestData(limit: 25).container.viewContext
    let quakeRequest = NSFetchRequest<Quake>(entityName: "Quake")
    quakeRequest.fetchLimit = 1
    quakeRequest.predicate = NSPredicate(format: "magnitude > 5.09")
    if let quake = try? context.fetch(quakeRequest), !quake.isEmpty {
        return EarthquakeDetailView(quake: quake[0])
    } else {
        return Text("Empty")
    }
}
