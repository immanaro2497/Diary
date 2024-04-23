//
//  DiaryApp.swift
//  Diary
//
//  Created by Immanuel on 07/04/24.
//

import SwiftUI

@main
struct DiaryApp: App {

    var body: some Scene {
        WindowGroup {
            DiaryContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .onAppear {
                    print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
                }
//                .environment(\.locale, .init(identifier: "hi"))
        }
    }
}

//struct DiaryApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}
