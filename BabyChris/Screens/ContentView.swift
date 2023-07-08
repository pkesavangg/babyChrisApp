//
//  ContentView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 21/03/23.
//

import SwiftUI
import AlertToast

struct ContentView: View {
    @ObservedObject var accountService: AccountService = AccountService.shared
    @StateObject var viewModel = NotificationViewModel()
    
    var body: some View {
        VStack{
            if(accountService.isLoading){
                ProgressView("Loading")
            }else{
                if(!accountService.isLoggedIn){
                    LandingView()
                }
                else {
                    MainView()
                }
            }
        }
        .blur(radius: viewModel.showLoader ? 5 : 0)
        .allowsHitTesting(viewModel.showLoader ? false : true)
        .alert(Text(viewModel.alertTitle), isPresented: $viewModel.showAlert,
               actions: {
            if(viewModel.inputField){
                TextField(viewModel.placeHolder, text: $viewModel.value)
                    .keyboardType( viewModel.isEmailField ? .emailAddress : .default)
                    .autocapitalization(.none)
            }
            Button(viewModel.cancelButtonText, action: {
                self.viewModel.inputField = false
                viewModel.onCancelClick()
            })
            Button(viewModel.submitButtonText,action: {
                self.viewModel.inputField = false
                viewModel.onSubmitClick(viewModel.value)
            })
        },message: {
            if let message = viewModel.alertMessage {
                Text(message)
                    .font(.largeTitle)
            }
        })
        .showToast(data: $viewModel.toastData, show: $viewModel.showToast, duration: viewModel.duration)
        .toast(isPresenting: $viewModel.showLoader) {
            AlertToast(type: .loading, title: viewModel.loaderMessage)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

