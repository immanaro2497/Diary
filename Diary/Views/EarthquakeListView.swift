//
//  EarthquakeListView.swift
//  Diary
//
//  Created by Immanuel on 19/04/24.
//

import SwiftUI
import CoreData
import MapKit

struct EarthquakeListView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.time, order: .reverse)], predicate: NSPredicate(format: "magnitude != nil"))
    private var quakes: FetchedResults<Quake>
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List(quakes, id: \.objectID) { quake in
                NavigationLink {
                    VStack {
                        EarthquakeDetailView(quake: quake)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(quake.place ?? "")
                            .font(.title)
                        if let time = quake.time {
                            Text(time, format: .dateTime.day().month(.twoDigits).year())
                                .font(.title3)
                        }
                        HStack {
                            Text(quake.magnitude!.doubleValue.formatted(.number.precision(.fractionLength(2))))
                                .frame(width: 90, height: 60)
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .background(.launchBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(quake.getQuakeIntensityColor)
                                .padding(.leading, 12)
                            Spacer()
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundStyle(.launchBackground)
                                .onTapGesture {
                                    isPresented.toggle()
                                }
                                .sheet(isPresented: $isPresented, content: {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                isPresented.toggle()
                                            }, label: {
                                                Text("Close")
                                            })
                                            .padding(12)
                                        }
                                        EarthquakeDetailView(quake: quake)
                                    }
                                })
                        }
                    }
                }

            }
            .listStyle(.plain)
        }
        .navigationTitle("Earthquakes")
        
    }
    
}

#Preview {
    NavigationStack {
        EarthquakeListView()
            .environment(\.managedObjectContext, PersistenceController.earthquakeTestData(limit: 25).container.viewContext)
    }
}
