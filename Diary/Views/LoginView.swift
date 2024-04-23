//
//  LoginView.swift
//  Diary
//
//  Created by Immanuel on 09/04/24.
//

import SwiftUI
import CoreData
import Combine
import OSLog

extension AnyTransition {
    
    static var hideTextField: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .scale.combined(with: .move(edge: .top)).combined(with: .opacity),
            removal: .scale.combined(with: .move(edge: .top)).combined(with: .opacity)
        )
    }
    
}

enum UserNameError: LocalizedError {
    case empty
    case duplicate
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Username cannot be empty"
        case .duplicate:
            return "Username taken. Please use another name"
        }
    }
}

enum PasswordError: LocalizedError {
    case notValid
    
    var errorDescription: String? {
        switch self {
        case .notValid:
            return "Password should contain atleast 1 uppercase, 1 lowercase, 1 number, 2 special characters from !@#$%&* and length should be 6 and above"
        }
    }
}

enum ConfirmPasswordError: LocalizedError {
    case notValid
    
    var errorDescription: String? {
        switch self {
        case .notValid:
            return "Confirm password did not match password"
        }
    }
}

struct LoginView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var visibleScreen: VisibleScreen
    
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<User>
    
    @State private var createNewUser: Bool = false
    
    @State private var name: String = ""
    @State private var nameError: UserNameError?
    let namePublisher = PassthroughSubject<String, Never>()
    
    @State private var password: String = ""
    @State private var passwordError: PasswordError?
    let passwordPublisher = PassthroughSubject<String, Never>()
    
    @State private var confirmPassword: String = ""
    @State private var confirmPasswordError: ConfirmPasswordError?
    
    @State private var showPassword: Bool = false
    
    @State private var showLoginErrorAlert: Bool = false
    
    @State private var loginViewWidthRatio: Double = {
        if UIDevice.isPad {
            return UIDevice.current.orientation.isPortrait ? 0.6 : 0.5
        } else {
            print(UIDevice.current.orientation.isPortrait, UIDevice.current.orientation.isLandscape, UIDevice.current.orientation.rawValue)
            return UIDevice.current.orientation.isPortrait ? 0.9 : 0.7
        }
    }()
    
    let logger = Logger(subsystem: "com.example.diary", category: "LoginView")
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 28) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                createNewUser.toggle()
                            }
                        }, label: {
                            Label(
                                title: { Text(createNewUser ? "Login" : "New user") },
                                icon: {}
                            )
                            .labelStyle(LoginButtonLabelStyle())
                        })
                        .animation(.spring(dampingFraction: 0.4), value: createNewUser)
                    }
                    .padding([.top, .bottom], 50)
                    
                    HStack {
                        let iconSize: CGFloat = 50
                        Spacer()
                        Text(createNewUser ? "New user" : "Login")
                            .font(Fonts.scaledFont20)
                            .padding(.leading, iconSize)
                        Spacer()
                        ZStack {
                            Circle()
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .font(.title2)
                                .foregroundStyle(.launchBackground)
                        }
                        .frame(width: iconSize, height: iconSize)
                        .onTapGesture {
                            showPassword.toggle()
                        }
                        .accessibilityLabel(showPassword ? "Hide password" : "Show password")
                    }
                    
                    TextField("Name", text: $name, prompt: Text(""))
                        .accessibilityElement(children: .ignore)
                        .modifier(LoginTextField(title: "Name", error: nameError))
                        .onChange(of: name) { _, newName in
                            if createNewUser {
                                namePublisher.send(newName)
                            }
                        }
                        .onReceive(namePublisher
                            .debounce(for: 0.6, scheduler: DispatchQueue.main)
                        ) { text in
                            print("comparing")
                            withAnimation {
                                if text.trimmingCharacters(in: .whitespaces).isEmpty {
                                    nameError = .empty
                                } else if users.first(where: { $0.username?.caseInsensitiveCompare(name) == .orderedSame }) != nil {
                                    nameError = .duplicate
                                } else {
                                    nameError = nil
                                }
                            }
                        }
                        .accessibilityElement(children: .combine)
                    
                    Group {
                        if showPassword {
                            TextField("Password", text: $password, prompt: Text(""))
                        } else {
                            SecureField("Password", text: $password, prompt: Text(""))
                        }
                    }
                    .textInputAutocapitalization(.never)
                    .modifier(LoginTextField(title: "Password", error: passwordError))
                    .onChange(of: password) { _, newPassword in
                        if createNewUser {
                            passwordPublisher.send(newPassword)
                        }
                    }
                    .onReceive(passwordPublisher
                        .debounce(for: 0.6, scheduler: DispatchQueue.main)
                    ) { text in
                        withAnimation {
                            let passwordValidCheck = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%&*].*[!@#$%&*]).{6,}$")
                            if passwordValidCheck.evaluate(with: text) {
                                passwordError = nil
                            } else {
                                passwordError = .notValid
                            }
                        }
                    }
                    .accessibilityElement(children: .combine)
                    
                    if createNewUser {
                        Group {
                            if showPassword {
                                TextField("Confirm password", text: $confirmPassword, prompt: Text(""))
                            } else {
                                SecureField("Confirm password", text: $confirmPassword, prompt: Text(""))
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .modifier(LoginTextField(title: "Confirm password", error: confirmPasswordError))
                        .transition(.hideTextField)
                        .onChange(of: password) { _, newValue in
                            withAnimation {
                                if newValue == confirmPassword {
                                    confirmPasswordError = nil
                                } else {
                                    confirmPasswordError = .notValid
                                }
                            }
                        }
                        .onChange(of: confirmPassword) { _, newValue in
                            withAnimation {
                                if newValue == password {
                                    confirmPasswordError = nil
                                } else {
                                    confirmPasswordError = .notValid
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        onPressLoginButton()
                    }, label: {
                        Label(
                            title: { Text(createNewUser ? "Create" : "Login") },
                            icon: {}
                        )
                        .labelStyle(LoginButtonLabelStyle())
                    })
                    .animation(.spring(dampingFraction: 0.6), value: createNewUser)
                    .alert(
                        "Login Failure",
                        isPresented: $showLoginErrorAlert,
                        actions: {
                            Button("OK", action: {})
                        },
                        message: {
                            Text("Username or Password did not match")
                        }
                    )
                    .accessibilityAction {
                        print("action voice")
                    }
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                .frame(width: geometry.size.width * loginViewWidthRatio)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                    loginViewWidthRatio = getLoginViewWidthRatio()
                })
            }
            .background(.launchBackground)
//            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
        }
    }
    
    func getLoginViewWidthRatio() -> Double {
        if UIDevice.isPad {
            return UIDevice.current.orientation.isPortrait ? 0.6 : 0.5
        } else {
            return UIDevice.current.orientation.isPortrait ? 0.9 : 0.7
        }
    }
    
    func onPressLoginButton() {
        if createNewUser {
//                        for index in 1...100000 {
                let user = User(context: viewContext)
                user.username = name
                user.password = password
//                        }
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        } else {
            let matchingUser = users.first(where: { $0.username?.caseInsensitiveCompare(name) == .orderedSame })
            if matchingUser?.password == password {
                visibleScreen = .diaryTabScreen
            } else {
                showLoginErrorAlert = true
            }
        }
    }
}

struct LoginButtonLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
        .font(Fonts.scaledFont20)
        .foregroundStyle(.white)
        .padding()
        .background(.launchBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 5)
        }
    }
}

struct LoginTextField: ViewModifier {
    let title: LocalizedStringKey
    let error: Error?
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Fonts.scaledFont17Bold)
            content
                .tint(.white)
                .frame(height: 54)
                .padding([.leading, .trailing])
                .font(Fonts.scaledFont17Bold)
                .foregroundStyle(.white)
                .background(.launchBackground)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                }
            if let error {
                Text(error.localizedDescription)
                    .font(Fonts.scaledFont15Bold)
                    .accessibilityLabel("Error. \(error.localizedDescription)")

            }
        }
        .foregroundStyle(error == nil ? .white : .yellow)
    }
    
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

#Preview {
    LoginView(visibleScreen: .constant(.loginScreen))
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

/*
 Button
 
 VStack(spacing: 24) {
     if startAnimation {
         Button(action: {
             
         }, label: {
             Label("Create account", systemImage: "arrow.right")
                 .labelStyle(LoginButtonLabelStyle())
         })
         .transition(.scale.combined(with: .opacity))
         
         Button(action: {
             
         }, label: {
             Label("Login", systemImage: "house.fill")
                 .labelStyle(LoginButtonLabelStyle())
         })
         .transition(.scale.combined(with: .opacity))
     }
 }
 .frame(width: 270)
 .frame(maxWidth: .greatestFiniteMagnitude)
 */
