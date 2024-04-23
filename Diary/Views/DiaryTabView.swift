//
//  DiaryTabView.swift
//  Diary
//
//  Created by Immanuel on 19/04/24.
//

import SwiftUI

enum DiaryTabDetailView: CaseIterable, Identifiable {
    case diaryDetails
    case earthquakeDetails
    case loginDetails
    
    var id: DiaryTabDetailView {
        self
    }
}

extension DiaryTabDetailView {
    
    @ViewBuilder
    var tabLabel: some View {
        switch self {
        case .diaryDetails:
            VStack {
                Text("Diary")
                Image(systemName: "42.circle")
            }
        case .earthquakeDetails:
            VStack {
                Text("Earthquake")
                Image(systemName: "42.circle")
            }
        case .loginDetails:
            VStack {
                Text("Login")
                Image(systemName: "42.circle")
            }
        }
    }
    
    @ViewBuilder
    var tabDetailView: some View {
        switch self {
        case .diaryDetails:
            DiaryDetailsView()
        case .earthquakeDetails:
            EarthquakeDetailsView()
        case .loginDetails:
            LoginDetailsView()
        }
    }
    
}

struct DiaryTabView: View {
    
    @State private var selectedTab: DiaryTabDetailView = .diaryDetails
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(DiaryTabDetailView.allCases) { tab in
                tab.tabDetailView
                    .tabItem {
                        tab.tabLabel
                    }
            }
        }
    }
}

#Preview {
    DiaryTabView()
}
