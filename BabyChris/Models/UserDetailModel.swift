//
//  UserDetailModel.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 08/04/23.
//

import Foundation


struct UserDetailModel: Hashable, Codable {
    var userUid: String
    var userName : String
    var userMailId : String
    var documentId: String = ""
    var isParticipating : Bool = false
    var childName: String = ""
    var dareMessage: String = ""
    var isDareCompleted: Bool = false
}
