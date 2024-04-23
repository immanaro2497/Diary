//
//  TestView.swift
//  Diary
//
//  Created by Immanuel on 07/04/24.
//

import SwiftUI
import Combine
import OSLog
import CoreData

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct TestView: View {
    
    let logger = Logger(subsystem: "com.example.diary", category: "LoginView")
    
//    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @State private var showingImage = false
    @State private var showingMessage = false
    @State private var selectedTab: DiaryTabDetailView = .diaryDetails
    
    init() {
        UITabBar.appearance().backgroundColor = .systemPink
        UITabBar.appearance().frame = CGRect(x: 0, y: 0, width: 500, height: 200)
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ForEach(DiaryTabDetailView.allCases) { tab in
                tab.tabDetailView
            }
        }
        
    }
}

#Preview {
    VStack {
        TestView()
    }
//    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
//    .background(.launchBackground)
}



