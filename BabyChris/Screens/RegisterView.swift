//
//  RegisterView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 31/03/23.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @FocusState private var focus : FocusText?
    
    var body: some View {
        VStack{
            Form{
                Section {
                    VStack(alignment: .leading)  {
                        
                        InputField(inputType: InputType.text,
                                   value: $viewModel.userName.value,
                                   placeholder: "Enter your first name here",
                                   textFieldLabel:  "First name",
                                   errorMessage: self.viewModel.userName.errorMessage,
                                   editingChanged: { isEditing in
                            self.viewModel.userName.isTouched  = true
                            if (!isEditing){
                                self.viewModel.userName.isUnfocused = true
                            }},
                                   commit: { focus = .email})
                        .focused($focus , equals: .userName)
                        .submitLabel(.next)
                        .padding(.top)
                        
                        InputField(inputType: InputType.email,
                                   value: $viewModel.email.value,
                                   placeholder: "info@greatergoods.com",
                                   textFieldLabel: "Email",
                                   errorMessage: self.viewModel.email.errorMessage,
                                   editingChanged: { isEditing in
                            self.viewModel.email.isTouched  = true
                            if (!isEditing){
                                self.viewModel.email.isUnfocused = true
                                
                            }},commit: {focus = .password})
                        .submitLabel(.next)
                        .focused($focus, equals: .email)
                        
                        InputField(inputType: InputType.password,
                                   value: $viewModel.password.value,
                                   placeholder: "******",
                                   textFieldLabel:  "Password",
                                   errorMessage: self.viewModel.password.errorMessage,
                                   editingChanged: {isEditing in
                            self.viewModel.password.isTouched = true
                            if (!isEditing){
                                self.viewModel.password.isUnfocused = true
                            }
                        },commit: {
                            focus = .confirmPassword
                        })
                        .focused($focus , equals: .password)
                        .submitLabel(.next)
                        
                        InputField(inputType: InputType.password,
                                   value: $viewModel.confirmPassword.value,
                                   placeholder: "******",
                                   textFieldLabel:  "Confirm Password",
                                   errorMessage: self.viewModel.confirmPassword.errorMessage,
                                   passwordMatchingErrorMessage: "",
                                   editingChanged: { isEditing in
                            DispatchQueue.main.async {
                                self.viewModel.confirmPassword.isTouched = true
                            }
                            if (!isEditing){
                                DispatchQueue.main.async {
                                    self.viewModel.confirmPassword.isUnfocused = true
                                }
                            }},commit: { focus = nil})
                        .focused($focus , equals: .confirmPassword)
                        .submitLabel(.done)
                    }
                    HStack {
                        Text("NOTE:")
                            .fontWeight(.bold)
                        Text("Ensure you do not forget your password.")
                    }
                    
                    .listRowSeparator(.hidden)
                    .font(.footnote)
                    
                    HStack{
                        Spacer()
                        Button {
                            if (!viewModel.isUserNameAlreadyTaken()){
                                Task{
                                    await viewModel.register()
                                }
                            }
                        } label: {
                            HStack{
                                Spacer()
                                Text("\(CommonConstants.register.uppercased()) \(Image(systemName: "arrow.right"))")
                                    .foregroundColor(Color("ColorWhite"))
                                    .clipShape(Rectangle())
                                    .frame(width: 300, height: 50)
                                    .background(Color("ColorButton"))
                                    .cornerRadius(10)
                                    .font(.subheadline)
                                    .minimumScaleFactor(0.5)
                                    .opacity(viewModel.isFormValid ? 1: 0.6)
                                Spacer()
                            }
                        }
                        .disabled(!viewModel.isFormValid)
                        
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
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
        .navigationTitle(CommonConstants.register)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
