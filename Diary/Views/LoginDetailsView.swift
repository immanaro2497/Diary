//
//  LoginDetailsView.swift
//  Diary
//
//  Created by Immanuel on 19/04/24.
//

import SwiftUI

struct LoginDetailsView: View {
    
    @State private var userPIN: String = ""
    @State private var canEditPIN: Bool = false
    
    var body: some View {
        
        VStack {
            
            TextField("User PIN", text: $userPIN, prompt: Text(""))
                .foregroundStyle(canEditPIN ? .red : .gray)
                .modifier(LoginTextField(title: "User PIN", error: nil))
                .foregroundStyle(canEditPIN ? .red : .gray)
//                .disabled(!canEditPIN)
            
            
            
        }
        
    }
}

#Preview {
    LoginDetailsView()
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(.launchBackground)
}
