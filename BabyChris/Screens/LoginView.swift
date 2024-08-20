//
//  LoginView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 31/03/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focus : FocusText?
    @Binding var currentViewTag: ViewTag?
    var body: some View {
        VStack{
           
            Form {
                
                Section {
                    VStack {
                        InputField(inputType: InputType.email,
                                   value: $viewModel.email.value,
                                   placeholder: "info@greatergoods.com",
                                   textFieldLabel: "Email",
                                   errorMessage: self.viewModel.email.errorMessage,
                                   editingChanged: { isEditing in
                            self.viewModel.email.isTouched  = true
                            if (!isEditing){
                                self.viewModel.email.isUnfocused = true
                                
                            }},commit: {focus = .email})
                        .submitLabel(.next)
                        .focused($focus, equals: .email)
                        
                        InputField(inputType: InputType.password,
                                   value: $viewModel.password.value,
                                   placeholder: "******",
                                   textFieldLabel:  "Password",
                                   errorMessage: self.viewModel.password.errorMessage,
                                   editingChanged: {isEditing in
                            DispatchQueue.main.async {
                                self.viewModel.password.isTouched = true
                            }
                            if (!isEditing){
                                DispatchQueue.main.async {
                                    self.viewModel.password.isUnfocused = true
                                }
                            }
                        },commit: {
                            focus = nil
                        })
                        .focused($focus , equals: .password)
                        .submitLabel(.next)
                        HStack {
                            Spacer()
                            Text("Forgot your Password?")
                                .foregroundColor(Color("ColorButton"))
                                .onTapGesture {
                                    self.viewModel.showForgotPasswordAlert()
                                }
                        }
                        .padding(.vertical, 8)
                        
                    }

                    HStack{
                        Button {
                            Task{
                               await viewModel.login()
                            }
                        } label: {
                            Text("\(CommonConstants.signIn.uppercased()) \(Image(systemName: "arrow.right"))")
                                .foregroundColor(Color("ColorWhite"))
                                .clipShape(Rectangle())
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color("ColorButton"))
                                .cornerRadius(10)
                                .font(.subheadline)
                                .minimumScaleFactor(0.5)
                                .opacity(viewModel.isFormValid ? 1: 0.6)
                        }
                        .disabled(!viewModel.isFormValid)
                    }
                    .listRowSeparator(.hidden)
                    
                    HStack {
                        Spacer()
                        Text("Create new Account")
                            .fontWeight(.bold)
                            .foregroundColor(Color("ColorButton"))
                            .font(.footnote)
                            .onTapGesture {
                                self.currentViewTag = ViewTag.registerView
                            }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { _ in
                viewModel.validateForm()
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
                viewModel.validateForm()
            }
            .resignOnDrag()
        }
        .navigationTitle(CommonConstants.login)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentViewTag: .constant(ViewTag.loginView))
    }
}
