//
//  RegisterViewModel.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 31/03/23.
//

import Foundation

class RegisterViewModel : ObservableObject {
    
    private var accountService =  AccountService.shared
    private var networkMonitor: NetworkMonitor = NetworkMonitor.shared
    private var gameService: GameService = GameService.shared
    private let userDefaults = UserDefaults.standard


    @Published var userName = FormFieldModel()
    @Published var email = FormFieldModel()
    @Published var password = FormFieldModel()
    @Published var confirmPassword = FormFieldModel()
    
    private let formValidator = FormValidator()
    
    
    func validateForm() {
        
        if let value = self.formValidator.validate(self.userName.value, validators: [EmptySpaceValidator()]).error?.errorMessage {
            self.userName.isValid = false
            self.userName.errorMessage = self.userName.isTouched ? value : ""
        }else{
            self.userName.isValid = true
            self.userName.errorMessage = ""
        }
        
        
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
        
        if let value = self.formValidator.validate(self.confirmPassword.value, validators: [MinLengthValidator(minLength: 6),
                                                                                            MaxLengthValidator(maxLength: 10),
                                                                                            MatchPasswordValidator(password: self.password.value)
                                                                                           ]).error?.errorMessage {
            self.confirmPassword.isValid = false
            self.confirmPassword.errorMessage = self.confirmPassword.isTouched ? value : ""
        }else{
            self.confirmPassword.isValid = true
            self.confirmPassword.errorMessage = ""
        }
        
    }
    
    var isFormValid: Bool {
        return userName.isValid && email.isValid && password.isValid && confirmPassword.isValid
    }
    
    
    func resetForm() {
            userName = FormFieldModel()
            email = FormFieldModel()
            password = FormFieldModel()
            confirmPassword = FormFieldModel()
    }
    
    func isUserNameAlreadyTaken() -> Bool {
        let isTaken = self.gameService.userDetails.contains { $0.userName.lowercased() == self.userName.value.lowercased() }
        if(isTaken){
            toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.signupError,
                                                                                  detail: "User name is already taken",
                                                                                  type: .Success)))
            return true
        }
        return false
    }
    
    func register() async {
        if(!networkMonitor.checkInternet()){
            return
        }
        loaderEventSubject.send(LoaderModel(showLoader: true, loaderMessage: LoaderMessages.signingUp))
        
        do {
            let data =  try await self.accountService.accountSignup(email: self.email.value, password: self.password.value)
            if let authResult = data {
                DispatchQueue.main.async {
//                    toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.successWithExclamation,
//                                                                                          detail: ToastMessages.registeredSuccessfully,
//                                                                                          type: .Success)))
                    loaderEventSubject.send(LoaderModel(showLoader: false))
                    self.resetForm()
                }
                let user = authResult.user
                self.userDefaults.set(user.uid, forKey: "userUid")
                self.gameService.sendUserInfo(userName: self.userName.value, userMailId: self.email.value, userUid: user.uid)
                self.gameService.getUserInfo()
                
            }
        } catch  {
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.signupError,
                                                                                      detail: error.localizedDescription,
                                                                                      type: .Success)))
                loaderEventSubject.send(LoaderModel(showLoader: false))
            }
        }
    }
    
    
}
