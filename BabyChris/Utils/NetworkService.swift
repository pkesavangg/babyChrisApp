//
//  NetworkManager.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 01/04/23.
//

import Foundation
import Network
import UIKit

class NetworkMonitor: ObservableObject {
    static let shared: NetworkMonitor = NetworkMonitor()
    

    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published var isConnected = true
    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
    
    // To check the mobile is connected to internet via Wi-fi or mobile-network or not.
     func checkInternet() -> Bool {
        if(!isConnected){
            toastEventsSubject.send(ToastModel(toastData: ToastModifier.ToastData(title: "No internet",
                                                                                  detail: "No connection detected. Please make sure you have internet access and try again.",
                                                                                  type: .Success)))
            return false
        }
        return true
    }
    
}
