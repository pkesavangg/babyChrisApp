//
//  ParticipantsListView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 23/04/23.
//

import SwiftUI

struct ParticipantsListView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        VStack{
            List {
                Section(header: HStack{ Text("Participants names:") }) {
                    ForEach(viewModel.participantsList, id: \.self) { data in
                        Text(data.userName)
                    }
                }
                
                Section(footer: VStack(alignment: .center) {
                    if viewModel.currentUserIsAdmin {
                        HStack{
                            Spacer()
                            Button("START THE GAME") {
                                Task{
                                   await viewModel.generateMomChild()
                                }
                            }
                            .font(.caption)
                             .padding()
                             .buttonStyle(.borderedProminent)
                             .disabled(viewModel.participantsList.count < 3 || viewModel.isGameStarted)
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Button("RESET THE GAME") {
                                Task{
                                    await viewModel.resetGame()
                                }
                            }
                            .font(.caption)
                            .padding()
                             .buttonStyle(.borderedProminent)
                             .disabled(!viewModel.isGameStarted)
                            Spacer()
                        }
                    }
                }){
                    EmptyView()
                }
            }
        }
    }
}

