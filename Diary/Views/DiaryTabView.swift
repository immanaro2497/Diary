//
//  DiaryTabView.swift
//  Diary
//
//  Created by Immanuel on 19/04/24.
//

import SwiftUI

enum DiaryTabDetailView: CaseIterable, Identifiable {
    case diaryDetails
    case earthquakeList
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
            HStack {
                Image(systemName: "book.closed.fill")
                if UIDevice.isPad {
                    Text("Diary")
                }
            }
        case .earthquakeList:
            HStack {
                Image(systemName: "globe.asia.australia")
                if UIDevice.isPad {
                    Text("Earthquake")
                }
            }
        case .loginDetails:
            HStack {
                Image(systemName: "person.text.rectangle.fill")
                if UIDevice.isPad {
                    Text("Login")
                }
            }
        }
    }
    
    @ViewBuilder
    var tabDetailView: some View {
        switch self {
        case .diaryDetails:
            DiaryDetailsView()
        case .earthquakeList:
            EarthquakeListView()
        case .loginDetails:
            LoginDetailsView()
        }
    }
    
}

struct DiaryTabView: View {
    
    @State private var selectedTab: DiaryTabDetailView = .diaryDetails
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ForEach(DiaryTabDetailView.allCases) { tab in
                    tab.tabDetailView
                        .safeAreaPadding(.bottom, 50)
                }
            }
            CustomTabView(selectedTab: $selectedTab)
        }
    }
}

struct CustomTabView: View {
    
    @Binding var selectedTab: DiaryTabDetailView
    let tabs = DiaryTabDetailView.allCases
    
    var body: some View {
        
        HStack {
            
            ForEach(tabs) { tab in
                tab.tabLabel
                    .foregroundStyle(selectedTab == tab ? .yellow : .white)
                    .onTapGesture {
                        selectedTab = tab
                    }
                if !(tab == tabs.last) {
                    Spacer()
                }
            }
            
        }
        .frame(width: UIDevice.isPad ? 600 : 200)
        .font(Fonts.scaledFont17Bold)
        .padding([.top, .bottom], UIDevice.isPad ? 16 : 12)
        .padding([.leading, .trailing], 32)
        .background(.launchBackground)
        .clipShape(Capsule())
        .shadow(color: .launchBackground, radius: 10)
        .padding([.leading, .trailing], UIDevice.isPad ? 24 : 16)
        
    }
    
}

#Preview {
    DiaryTabView()
}
