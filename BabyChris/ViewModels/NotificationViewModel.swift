//
//  NotificationViewModel.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 30/04/23.
//

struct LoaderModel {
    var showLoader: Bool
    var loaderMessage: String?
}

struct ToastModel{
    var toastData: ToastModifier.ToastData
    var isSheetModel: Bool?
    var duration: Double?
}

struct AlertModel {
    var title:String
    var message: String?
    var submitButtonText: String?
    var cancelButtonText: String?
    var placeHolder: String?
    var value: String?
    var inputField: Bool?
    var isEmailField: Bool?
    var onSubmitClick: (String)->() = { _ in }
    var onCancelClick: ()->() = { }
}



import Foundation
import SwiftUI
import Combine

var toastEventsSubject: PassthroughSubject = PassthroughSubject<ToastModel, Never>();
var loaderEventSubject: PassthroughSubject = PassthroughSubject<LoaderModel, Never>();
var alertEventsSubject: PassthroughSubject = PassthroughSubject<AlertModel, Never>();


class NotificationViewModel: ObservableObject {
    
    var toastCancellable: AnyCancellable?
    var loaderCancellable: AnyCancellable?
    var alertCancellable: AnyCancellable?
    
    @Published var toastData: ToastModifier.ToastData = ToastModifier.ToastData(title: "",  type: .Success)
    @Published var showToast: Bool?
    @Published var duration: Double = 3
    
    @Published var showLoader: Bool = false
    @Published var loaderMessage: String = "Loading..."
    
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String?
    @Published var submitButtonText: String = ""
    @Published var cancelButtonText: String = ""
    @Published var value: String = ""
    @Published var placeHolder: String = ""
    @Published var inputField: Bool = false
    @Published var isEmailField: Bool = false
    var onSubmitClick: (String)->() = { _ in }
    var onCancelClick: ()->() = { }
    
    init() {
        toastCancellable = toastEventsSubject.sink(receiveValue: { value in
            let isSheetModal = value.isSheetModel ?? false
            if !isSheetModal {
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.showToast = false
                    withAnimation(Animation.spring()) {
                        self.showToast = true
                        self.toastData = value.toastData
                        self.duration = value.duration ?? 3
                    }
                }
            }
        })
        
        loaderCancellable = loaderEventSubject.sink(receiveValue: { value in
            DispatchQueue.main.async {
                self.showLoader = value.showLoader
                self.loaderMessage =  value.loaderMessage ?? "Loading..."
            }
            
        })
        
        alertCancellable = alertEventsSubject.sink(receiveValue: { alertData in
            self.alertTitle = alertData.title
           
            withAnimation(Animation.spring()){
                self.showAlert = true
            }
            self.onSubmitClick = alertData.onSubmitClick
            self.onCancelClick = alertData.onCancelClick
            self.value = alertData.value ?? ""
            self.inputField = alertData.inputField ?? false
            self.alertMessage = alertData.message ?? nil
            self.isEmailField = alertData.isEmailField ?? false
            self.placeHolder = alertData.placeHolder ?? CommonConstants.required
            self.cancelButtonText = alertData.cancelButtonText ?? "CANCEL"
            self.submitButtonText = alertData.submitButtonText ?? "SUBMIT"
        })
    }
    deinit{
        toastCancellable?.cancel()
        loaderCancellable?.cancel()
        alertCancellable?.cancel()
    }
    
}
