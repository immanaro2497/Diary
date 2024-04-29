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
        
        HStack {
            
                    HStack {
                        Image(systemName: "book.closed.fill")
                        if UIDevice.isPad {
                            Text("Diary")
                        }
                    }
                .foregroundStyle(selectedTab == .diaryDetails ? .yellow : .white)
                .onTapGesture {
                    selectedTab = .diaryDetails
                }

            Spacer()
            
                    HStack {
                        Image(systemName: "globe.asia.australia")
                        if UIDevice.isPad {
                            Text("Earthquake")
                        }
                    }
                .foregroundStyle(selectedTab == .earthquakeList ? .yellow : .white)
                .onTapGesture {
                    selectedTab = .earthquakeList
                }
            
            Spacer()
            
                    HStack {
                        Image(systemName: "person.text.rectangle.fill")
                        if UIDevice.isPad {
                            Text("Login")
                        }
                    }
                .foregroundStyle(selectedTab == .loginDetails ? .yellow : .white)
                .onTapGesture {
                    selectedTab = .loginDetails
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
    VStack {
        TestView()
    }
//    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
//    .background(.launchBackground)
}



