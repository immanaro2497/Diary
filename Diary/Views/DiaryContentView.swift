//
//  DiaryContentView.swift
//  Diary
//
//  Created by Immanuel on 18/04/24.
//

import SwiftUI

enum VisibleScreen {
    case launchScreen
    case loginScreen
    case diaryTabScreen
}

struct DiaryContentView: View {
    
    @State private var visibleScreen: VisibleScreen = .launchScreen
    @State private var networkMonitor = NetworkMonitor()
    @State private var toastMessage = ""
    
    var body: some View {
        //            TestView()
        //                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        Group {
            switch visibleScreen {
            case .launchScreen:
                LaunchScreenView(visibleScreen: $visibleScreen)
            case .loginScreen:
                LoginView(visibleScreen: $visibleScreen)
            case .diaryTabScreen:
                DiaryDetailsView()
            }
        }
        .overlay {
            if !toastMessage.isEmpty {
                ToastView(message: $toastMessage)
            }
        }
        .onChange(of: networkMonitor.status) { _, newValue in
            if newValue == .offline {
                toastMessage = "Network offline"
            } else {
                toastMessage = "Network online"
            }
        }

    }
}

#Preview {
    DiaryContentView()
}
