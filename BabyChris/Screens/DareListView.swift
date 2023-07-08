//
//  DareListView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 23/04/23.
//

import SwiftUI

struct DareListView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        VStack{
            if (viewModel.isGameStarted){
                List {
                    Section(header: HStack {
                        Text("Dare List Details")
                            .font(.headline)
                    }) {
                        ForEach(viewModel.participantsList, id: \.self) { data in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Dare Assigned to:")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text(data.userName)
                                        .font(.headline)
                                    
                                    Text("Dare Message:")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text(data.dareMessage)
                                        .font(.body)
                                    
                                    Text("Completion Status:")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    if data.isDareCompleted {
                                        Text("Completed")
                                            .foregroundColor(.green)
                                    } else {
                                        Text("Not Completed")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                Text("Game has not yet started.")
                    .bold()
                    .font(.title2)
            }
        }
    }
}

