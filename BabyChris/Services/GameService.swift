//
//  GameService.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 21/03/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class GameService: ObservableObject {
    // Make it as a singleton class
    static let shared: GameService = GameService()
    private let userDefaults = UserDefaults.standard
    
    let dataBase = Firestore.firestore()
    
    @Published var userDetails = [UserDetailModel]()
    @Published var currentUserInfo: UserDetailModel?
    
    var isCurrentUserParticipating = CurrentValueSubject<Bool, Never>(false)
    
    
    private var showToast = false
    private var toastData: ToastModifier.ToastData = ToastModifier.ToastData(title: "",  type: .Success)
    
    
    init(){
        self.getUserInfo()
    }
    
    func getDocumentId(userName : String) -> String {
        if let value = userDetails.first(where: {$0.userName == userName}) {
            return value.documentId
        }
        return ""
    }
    
    func getCurrentUserMailId() -> String{
        if let currentUserUid = Auth.auth().currentUser?.email{
            return currentUserUid
        }
        return ""
    }
    
    func sendUserInfo(userName : String, userMailId: String, userUid: String) {
        let newDocument = dataBase.collection("userDetails").document()
        newDocument.setData(["userUid": userUid,
                             "userMailId": userMailId,
                             "userName": userName,
                             "dateField": Date.timeIntervalSinceReferenceDate,
                             "documentId" : newDocument.documentID,
                             "isParticipating" : false,
                             "childName" : "",
                             "dareMessage" : "",
                             "isDareCompleted" : false
                            ]) { (error) in
            if error != nil {
                print("Successfully saved data to firestore")
            }else{
            }
        }
    }
    
    
    func getUserInfo() {
        dataBase.collection("userDetails")
            .order(by: "dateField")
            .addSnapshotListener{ (querySnapshot , error ) in
                if let e = error {
                    print("There was an issue retrieving data from firestore \(e)")
                }else{
                    print("Successfullu retrieving data from firestore")
                    
                    if let snapShotDocuments =  querySnapshot?.documents {
                        self.userDetails = []
                        loaderEventSubject.send(LoaderModel(showLoader: true))
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            if let userUid = data["userUid"] as? String,
                               let userMailId = data["userMailId"] as? String,
                               let userName = data["userName"] as? String,
                               let documentId = data["documentId"] as? String,
                               let isParticipating = data["isParticipating"] as? Bool,
                               let childName = data["childName"] as? String,
                               let dareMessage = data["dareMessage"] as? String,
                               let isDareCompleted = data["isDareCompleted"] as? Bool {
                                
                                if userMailId == self.getCurrentUserMailId() {
                                    self.currentUserInfo = UserDetailModel(userUid: userUid,
                                                                           userName: userName,
                                                                           userMailId: userMailId,
                                                                           documentId: documentId,
                                                                           isParticipating: isParticipating,
                                                                           childName: childName,
                                                                           dareMessage: dareMessage,
                                                                           isDareCompleted: isDareCompleted)
                                    self.isCurrentUserParticipating.send(isParticipating)
                                }
                                self.userDetails.append(UserDetailModel(userUid: userUid,
                                                                        userName: userName,
                                                                        userMailId: userMailId,
                                                                        documentId: documentId,
                                                                        isParticipating: isParticipating,
                                                                        childName: childName,
                                                                        dareMessage: dareMessage,
                                                                        isDareCompleted: isDareCompleted))
                            }                        }
                        loaderEventSubject.send(LoaderModel(showLoader: false))
                    }
                }
            }
    }
    
    func enrollPlayer() async throws -> Bool? {
        return try await withCheckedThrowingContinuation { continuation in
            if let documentId = self.currentUserInfo?.documentId {
                dataBase.collection("userDetails").document(documentId)
                    .setData(["isParticipating": true] ,merge: true) { (error) in
                        if let error = error {
                            continuation.resume(throwing: error)
                        }else{
                            continuation.resume(returning: true)
                        }
                    }
            }
        }
    }
    
    
    func generateMomAndChild() async throws -> Bool? {
        var completionCount = 0
        var error: Error?
        var result: Bool?
        return try await withCheckedThrowingContinuation { continuation in
            var checkFlag = true
            
            var childNames = [String : String]()
            let participantsList =  userDetails.filter { $0.isParticipating == true }
            for player in participantsList {
                checkFlag = true
                while(checkFlag == true){
                    let randomNumber = Int.random(in: 0 ... participantsList.count - 1)
                    if( !childNames.contains(where: {$0.value == participantsList[randomNumber].userName})  && participantsList[randomNumber].userName != player.userName ){
                        childNames.updateValue( participantsList[randomNumber].userName, forKey: player.userName)
                        checkFlag = false
                    }
                }
            }
            
            for (memberName, childName) in childNames {
                dataBase.collection("userDetails").document(getDocumentId(userName: memberName))
                    .setData(["childName": childName] ,merge: true) {  (setDataError) in
                        completionCount += 1
                        
                        if let setDataError = setDataError {
                            error = setDataError
                        }
                        
                        if completionCount == childNames.count {
                            if let error = error {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume(returning: result)
                            }
                        }
                    }
            }
        }
    }
    
    func sendDareCompletionStatus(_ isDareCompleted: Bool, documentId: String) async throws -> Bool? {
        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection("userDetails").document(documentId)
                .setData(["isDareCompleted": isDareCompleted] ,merge: true) { (error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }else{
                        continuation.resume(returning: true)
                    }
                }
        }
    }
    
    func sendDareMessage(dareMessage: String) async throws -> Bool? {
        return try await withCheckedThrowingContinuation { continuation in
            guard let childName = currentUserInfo?.childName else {return}
            
            dataBase.collection("userDetails").document(getDocumentId(userName: childName))
                .setData(["dareMessage": dareMessage] ,merge: true) { (error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }else{
                        continuation.resume(returning: true)
                    }
                }
        }
    }
    
    func resetGame() async throws -> Bool? {
        var completionCount = 0
        var error: Error?
        var result: Bool?
        return try await withCheckedThrowingContinuation { continuation in
            for player in userDetails {
                dataBase.collection("userDetails").document(player.documentId)
                    .setData(["isParticipating": false,
                              "childName" : "",
                              "isDareCompleted" : false,
                              "dareMessage" : ""], merge: true) { (setDataError) in
                        completionCount += 1
                        if let setDataError = setDataError {
                            error = setDataError
                        }
                        
                        if completionCount == self.userDetails.count {
                            if let error = error {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume(returning: result)
                            }
                        }
                    }
            }
        }
    }
    
}
