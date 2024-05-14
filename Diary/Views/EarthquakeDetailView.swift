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
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    let quake: Quake
    
    var body: some View {
        ScrollView {
            VStack {
                Map(position: $cameraPosition) {
                    if let latitude = quake.quakeLocation?.latitude?.doubleValue,
                       let longitude = quake.quakeLocation?.longitude?.doubleValue {
                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    //                    Marker(coordinate: location) {
    //                        Label(quake.place ?? "place", systemImage: "bolt.trianglebadge.exclamationmark.fill")
    //                    }
    //                    .tint(quake.getQuakeIntensityColor)
                        Annotation(quake.place ?? "place", coordinate: location, anchor: .center) {
                            Image(systemName: "bolt.trianglebadge.exclamationmark.fill")
                                .foregroundStyle(quake.getQuakeIntensityColor)
                        }
                        MapCircle(center: location, radius: 5000)
                            .foregroundStyle(.red.opacity(0.2))
                    }
                }
                    .frame(maxWidth: .greatestFiniteMagnitude)
                    .aspectRatio(2, contentMode: .fit)
                    .padding(.all, 24)
                    .onAppear {
                        if let latitude = quake.quakeLocation?.latitude?.doubleValue,
                           let longitude = quake.quakeLocation?.longitude?.doubleValue {
                            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                            let region = MKCoordinateRegion(center: location, span: span)
                            cameraPosition = .region(region)
                        }
                    }
                    .onMapCameraChange(frequency: .onEnd, { context in
                        visibleRegion = context.region
                    })
                HStack {
                    VStack(alignment: .leading) {
                        Text(quake.title ?? "title")
                        if let time = quake.time {
                            Text(time, format: .dateTime.day().month(.wide).year())
                        }
                    }
                    Spacer()
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(quake.getQuakeIntensityColor)
                        .padding(.leading, 12)
                }
                .padding()
            }
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
