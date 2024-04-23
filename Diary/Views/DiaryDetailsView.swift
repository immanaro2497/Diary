//
//  DiaryDetailsView.swift
//  Diary
//
//  Created by Immanuel on 19/04/24.
//

import SwiftUI

struct DiaryDetailsView: View {
    
    var body: some View {
        List {
            ForEach(1..<50) { value in
                Text(value, format: .number)
            }
        }
    }
    
}

#Preview {
    DiaryDetailsView()
}
