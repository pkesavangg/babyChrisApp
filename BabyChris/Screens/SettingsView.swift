//
//  SettingsView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 02/07/23.
//

import SwiftUI

struct SettingsView: View {
    private let service = AccountService.shared
    @ObservedObject var viewModel =  SettingsViewModel()
    var body: some View {
        VStack {
            List {
                Section("Account Info") {
                    HStack{
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.gray)
                            .font(.largeTitle)
                            .padding(.trailing, 5)
                        VStack(alignment:.leading, spacing: 5){
                            Text(viewModel.currentUserDetails?.userName ?? "")
                                .fontWeight(.bold)
                            Text(viewModel.currentUserDetails?.userMailId ?? "")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Button {
                    alertEventsSubject.send(AlertModel(title: "Are you sure you want to logout",
                                                                               submitButtonText: "YES",
                                                                               onSubmitClick: { value in
                                                service.logout()
                                            }))
                } label: {
                    Text("Log out")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
