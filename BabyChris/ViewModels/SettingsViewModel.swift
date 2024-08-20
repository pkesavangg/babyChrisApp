//
//  SettingsViewModel.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 02/07/23.
//

import Foundation
import Combine


class SettingsViewModel: ObservableObject {
    @Published public var currentUserDetails : UserDetailModel?
    private var gameService: GameService = GameService.shared
    private var networkMonitor: NetworkMonitor = NetworkMonitor.shared
    var currentUserCancellable: Cancellable?
    
    init() {
        currentUserCancellable = gameService.$currentUserInfo.sink(receiveValue: { value in
            if let info = value {
                self.currentUserDetails = info
            }
        })
    }
    
    func getAdminDetail() -> UserDetailModel? {
        if self.gameService.userDetails.filter({$0.isParticipating}).count > 0 {
            return self.gameService.userDetails.filter({$0.isParticipating})[0]
        }
       return nil
    }
    
    
    deinit{
        currentUserCancellable?.cancel()
    }
}
