//
//  MainView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 31/03/23.
//

import SwiftUI

struct MainView: View {
    private let service = AccountService.shared
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        NavigationView {
            VStack{
                if viewModel.isParticipating == nil {
                    ProgressView()
                }else{
                    if let isParticipating = viewModel.isParticipating {
                        if(!isParticipating) {
                            GameInfoView()
                        }else {
                            TabView {
                                ParticipantsListView(viewModel: viewModel)
                                    .tabItem {
                                        Label("Participants", systemImage: "person.crop.circle.fill")
                                    }
                                
                                DareListView(viewModel: viewModel)
                                    .tabItem {
                                        Label("Dare Details", systemImage: "list.bullet.circle.fill")
                                    }
                                
                                SendingDareView(viewModel: viewModel)
                                    .tabItem {
                                        Label("Send Dare", systemImage: "paperplane.circle.fill")
                                    }
                                SettingsView()
                                    .tabItem {
                                        Label("Settings", systemImage: "gear.circle.fill")
                                    }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Secret Santa", displayMode: .inline)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
