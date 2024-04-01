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
                
                Section(footer: VStack(alignment: .center, spacing: 20) {
                    if viewModel.currentUserIsAdmin {
                        HStack{
                            Spacer()
                            
                            Button {
                                Task{
                                   await viewModel.generateMomChild()
                                }
                            } label: {
                                Text("START THE GAME")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.participantsList.count < 3 || viewModel.isGameStarted ? Color.gray: Color.blue)
                                    .opacity(viewModel.participantsList.count < 3 || viewModel.isGameStarted ? 0.5: 1)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    
                            }
                             .disabled(viewModel.participantsList.count < 3 || viewModel.isGameStarted)
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Button {
                                Task{
                                    await viewModel.resetGame()
                                }
                            } label: {
                                Text("RESET THE GAME")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(!viewModel.isGameStarted ? Color.gray : Color.blue)
                                    .foregroundColor(.white)
                                    .opacity(!viewModel.isGameStarted ? 0.5: 1)
                                    .cornerRadius(10)
                            }
                           
                             //.buttonStyle(.borderedProminent)
                             .disabled(!viewModel.isGameStarted)
                            Spacer()
                        }
                    }
                }){
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

