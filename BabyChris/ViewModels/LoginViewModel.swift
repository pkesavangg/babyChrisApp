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
