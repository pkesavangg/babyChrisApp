//
//  GameInfoView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 02/04/23.
//

import SwiftUI

struct GameInfoView: View {
    @StateObject private var viewModel = GameInfoViewModel()
    private let service = AccountService.shared
    var body: some View {
            VStack{
                VStack{
                    Image("SplashScreenImage")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                    Text(GameInfoConstants.welcomeText)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.title)
                        .frame(width: UIScreen.screenWidth * 0.75)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    Text(GameInfoConstants.gameInfoText)
                        .foregroundColor(.black)
                        .font(.callout)
                        .frame(width: UIScreen.screenWidth * 0.85)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Link(GameInfoConstants.learnAboutGame, destination: URL(string: webLinks.gameInfoLink )!)
                        .font(.callout)
                        .foregroundColor(.blue)
                        .padding(.bottom)
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            alertEventsSubject.send(AlertModel(title: "Are you sure you want to logout",
                                                               submitButtonText: "YES",
                                                               onSubmitClick: { value in
                                self.service.logout()
                            }))
                            
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        
                    }
                }
                HStack{
                    Spacer()
                    Button {
                        Task{
                            await viewModel.addParticipant()
                        }
                    } label: {
                        Text("JOIN")
                            .fontWeight(.bold)
                            .accentColor(.blue)
                            .frame(minWidth: 100, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    Spacer()
                }
            }
        
       
    }
}

struct GameInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GameInfoView()
    }
}
