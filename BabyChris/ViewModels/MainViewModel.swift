//
//  ContentViewModel.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 11/04/23.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    private var gameService: GameService = GameService.shared
    private var networkMonitor: NetworkMonitor = NetworkMonitor.shared
    
    @Published public var isParticipating : Bool?
    @Published public var userDetails : [UserDetailModel] = []
    @Published public var currentUserDetails : UserDetailModel?
    @Published public var isGameStarted : Bool = false
    @Published public var dareMessage : String = ""
    @Published public var isDareAssignedAlready : Bool = false
    @Published public var isDareCompleted : Bool = false
    private var childInfo: UserDetailModel?
    var currentUserCancellable: Cancellable?
    var userDetailsCanacellable: Cancellable?
    
    init() {
        currentUserCancellable = gameService.$currentUserInfo.sink(receiveValue: { value in
            if let info = value {
                self.currentUserDetails = info
                self.isParticipating = info.isParticipating
                self.isGameStarted = info.childName != ""
            }
        })
        
        userDetailsCanacellable = gameService.$userDetails.sink(receiveValue: { userDetails in
            if userDetails.count > 0 {
                self.userDetails = userDetails
            }
            
            if let childDetails = userDetails.first(where: {$0.userName == self.currentUserDetails?.childName})  {
                self.childInfo = childDetails
                if childDetails.dareMessage != "" {
                    self.isDareAssignedAlready = true
                    self.isDareCompleted = childDetails.isDareCompleted
                }
            }
        })
    }
    
    var currentUserIsAdmin : Bool {
        guard let currentUserMailId = self.currentUserDetails?.userMailId else {
            return false
        }
        print(currentUserMailId, self.userDetails[0].userMailId,currentUserMailId ==  self.userDetails[0].userMailId)
        if let participatingUser = self.gameService.userDetails.first(where: { $0.isParticipating }) {
            return currentUserMailId == participatingUser.userMailId
        }
        return false

    }
    
    var participantsList: [UserDetailModel] {
        return userDetails.filter({$0.isParticipating})
    }
    
    func sendDareCompletionStatus(_ isDareCompleted: Bool) async {
        if(!networkMonitor.checkInternet()){
            return
        }
        
        loaderEventSubject.send(LoaderModel(showLoader: true))
        
        do {
            let _ =   try await gameService.sendDareCompletionStatus(isDareCompleted, documentId: self.childInfo?.documentId ?? "")
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.successWithExclamation,
                                                                                      detail: "Dare completion status updated.",
                                                                                      type: .Success)))
                loaderEventSubject.send(LoaderModel(showLoader: false))
                self.dareMessage = ""
            }
        } catch  {
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Error",
                                                                                      detail: error.localizedDescription,
                                                                                      type: .Success)))
                loaderEventSubject.send(LoaderModel(showLoader: false))
            }
        }
    }
    
    func sendDare() async {
        if(!networkMonitor.checkInternet()){
            return
        }
        
        loaderEventSubject.send(LoaderModel(showLoader: true))
        
        do {
         let _ =   try await gameService.sendDareMessage(dareMessage: self.dareMessage)
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.successWithExclamation,
                                                                                      detail: "Dare send successfully.",
                                                                                      type: .Success)))
                loaderEventSubject.send(LoaderModel(showLoader: false))
                self.dareMessage = ""
            }
        } catch  {
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Error",
                                                                                      detail: error.localizedDescription,
                                                                                      type: .Success)))
                loaderEventSubject.send(LoaderModel(showLoader: false))
            }
        }
    }
    
    func generateMomChild() async {
        if(!networkMonitor.checkInternet()){
            return
        }
        
        do {
            let _ =  try await gameService.generateMomAndChild()
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.successWithExclamation,
                                                                                      detail: "Successfully generated mom and child.",
                                                                                      type: .Success)))
            }
        } catch  {
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Error",
                                                                                      detail: error.localizedDescription,
                                                                                      type: .Success)))
            }
        }
    }
    
    func resetGame() async {
        
        if(!networkMonitor.checkInternet()){
            return
        }
        
        loaderEventSubject.send(LoaderModel(showLoader: true))
        do {
            let _ =  try await gameService.resetGame()
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.successWithExclamation,
                                                                                      detail: "Successfully reset the game.",
                                                                                      type: .Success)))
            }
        } catch {
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "Error",
                                                                                      detail: error.localizedDescription,
                                                                                      type: .Success)))
                loaderEventSubject.send(LoaderModel(showLoader: false))
            }
        }
    }
    
    deinit{
        currentUserCancellable?.cancel()
    }
    
}
