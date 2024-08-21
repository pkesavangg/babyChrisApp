//
//  LoginViewModel.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 01/04/23.
//

import Foundation


class LoginViewModel: ObservableObject {
    
    private var accountService =  AccountService.shared
    private var networkMonitor: NetworkMonitor = NetworkMonitor.shared
    private var gameService: GameService = GameService.shared
    private let userDefaults = UserDefaults.standard
    @Published var email = FormFieldModel()
    @Published var password = FormFieldModel()
    private let formValidator = FormValidator()
    let emailValidator = EmailValidator()
    func validateForm() {
        if let value = self.formValidator.validate(self.email.value, validators: [EmailValidator()]).error?.errorMessage {
            self.email.isValid = false
            self.email.errorMessage = self.email.isTouched ? value : ""
        }else{
            self.email.isValid = true
            self.email.errorMessage = ""
        }
        
        if let value = self.formValidator.validate(self.password.value, validators: [MinLengthValidator(minLength: 6)]).error?.errorMessage {
            self.password.isValid = false
            self.password.errorMessage = self.password.isTouched  ? value : ""
        }else{
            self.password.isValid = true
            self.password.errorMessage = ""
        }
    }
    
    var isFormValid: Bool {
        return email.isValid && password.isValid
    }
    
    func resetForm() {
        email = FormFieldModel()
        password = FormFieldModel()
    }
    
    func showForgotPasswordAlert() {
        alertEventsSubject.send(AlertModel(title: "Password Reset",
                                           message: "Enter your email below",
                                           submitButtonText: "Submit",
                                           cancelButtonText: "Cancel",
                                           placeHolder: CommonConstants.email,
                                           value: self.email.value,
                                           inputField: true,
                                           isEmailField: true,
                                           onSubmitClick: { value in
            
            Task {
                await self.resetPassword(value)
            }
            
        }))
    }
    
    func resetPassword(_ value: String) async{
        if(!self.networkMonitor.isConnected){
            toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Password Reset Error",
                                                                                  detail: "No connection detected. Please make sure you have internet access and try again.",
                                                                                  type: .Success)))
            return
        }
        
        if(!self.emailValidator.isValid(value).isValid){
            toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Password Reset Error",
                                                                                  detail: "The email address you provided is invalid. Please try again.",
                                                                                  type: .Success)))
            return
        }
        do {
           let result = try await self.accountService.forgotPassward(email: value)
           if let result = result {
               if(result) {
                   DispatchQueue.main.async {
                       toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Reset link sent to your email. Please check that.",
                                                                                             type: .Success)))
                   }
               }
            }
        } catch (let error) {
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Password Reset Error",
                                                                                      detail: error.localizedDescription,
                                                                                      type: .Success)))
            }
        }
        
    }
    
    func login() async {
        if(!networkMonitor.checkInternet()){
            return
        }
        loaderEventSubject.send(LoaderModel(showLoader: true, loaderMessage: LoaderMessages.loggingIn))
        do {
            let data =  try await self.accountService.accountSignIn(email: self.email.value, password: self.password.value)
            if let authResult = data {
                DispatchQueue.main.async {
                    loaderEventSubject.send(LoaderModel(showLoader: false))
                    let user = authResult.user
                    self.userDefaults.set(user.uid, forKey: "userUid")
                    self.gameService.getUserInfo()
                    self.resetForm()
                }
                
            }
        } catch  {
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.loginError,
                                                                                      detail: error.localizedDescription,
                                                                                      type: .Success)))
                loaderEventSubject.send(LoaderModel(showLoader: false))
                
            }
        }
    }
    
    
}
