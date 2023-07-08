//
//  GameInfoViewModel.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 08/04/23.
//

import Foundation

class GameInfoViewModel: ObservableObject {
    private var gameService: GameService = GameService.shared
    private var networkMonitor: NetworkMonitor = NetworkMonitor.shared
    
    init() {}
    
    func addParticipant() async {
        if(!networkMonitor.checkInternet()){
            return
        }
        
        do {
           let _ = try await self.gameService.enrollPlayer();
            DispatchQueue.main.async {
                toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: CommonConstants.successWithExclamation,
                                                                                      detail: "Successfully join the game.",
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
    
}
