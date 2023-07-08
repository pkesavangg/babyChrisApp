//
//  AccountService.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 21/03/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AccountService: ObservableObject {
    // Make it as a singleton class
    static let shared: AccountService = AccountService()
    private let userDefaults = UserDefaults.standard
    
    
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    
    init() {
        self.isLoading = true
        if UserDefaults.standard.string(forKey: "userUid") != nil {
            self.isLoggedIn = true
            self.isLoading = false
        }
        self.isLoading = false
    }
    
    
    //Account creation in firebase.
    func accountSignup(email: String, password: String ) async throws -> AuthDataResult? {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let errorValue = error {
                    continuation.resume(throwing: errorValue)
                }
                else {
                    continuation.resume(returning: authResult)
                    self.isLoggedIn = true
                }
            }
        }
    }
    
    //Login to already created accoutn.
    func accountSignIn(email: String, password: String) async throws -> AuthDataResult? {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let errorValue = error {
                    continuation.resume(throwing: errorValue)
                } else {
                    continuation.resume(returning: authResult)
                    self.isLoggedIn = true
                }
            }
        }
    }
    
    
    //Log out functionality call firebase signout method and remove the local storage key UserId.
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            UserDefaults.standard.removeObject(forKey: "userUid")
        } catch  _ as NSError {
        }
    }
    
}
