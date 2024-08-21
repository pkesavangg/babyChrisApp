//
//  LandingView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 31/03/23.
//

import SwiftUI

struct LandingView: View {
    
    @State var showLoginView = false
    @State var showRegisterView = false
    @State private var currentViewTag: ViewTag?
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ZStack{
                    Color(.white)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                       Spacer()
                        VStack(spacing: 30) {
                            HStack{
                                Spacer()
                                Image("onboarding-gift")
                                
                                    .resizable()
                                    .frame(maxWidth: min(geometry.size.width, 300),
                                           maxHeight:min(geometry.size.width, 300))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            VStack(spacing: 40) {
                                HStack {
                                    Text("Embark on a Magical Journey with Secret Santa!")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("ColorButton"))
                                        .lineSpacing(10)
                                        .font(.title2)
                                }
                                HStack {
                                    Text("Explore Secret Santa magical world! Dive into playful challenges. Log in or register to start your adventure!")
                                }
                            }
                            .padding(.horizontal, 25)
                            .multilineTextAlignment(.center)
                            Spacer()
                            HStack {
                                Spacer()
                                NavigationLink( destination: LoginView(currentViewTag: $currentViewTag), tag: ViewTag.loginView, selection: $currentViewTag){
                                    Text("Login")
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 15)
                                        .background(Color("ColorButton"))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .shadow(color: Color("ColorButton"), radius: 3)
//                                    Button(action: {
//                                        self.showLoginView = true
//                                    }, label: {
//
//                                            
//                                    })
                                    
                                }
                                Spacer()
                                NavigationLink( destination: RegisterView(currentViewTag: $currentViewTag), tag: ViewTag.registerView, selection: $currentViewTag) {
                                    Text("Register")
                                        .foregroundColor(Color("ColorButton"))
                                        .fontWeight(.bold)
                                        .font(.title3)
//                                    Button(action: {
//                                        self.showRegisterView = true
//                                    }, label: {
//                                        Text("Register")
//                                            .foregroundColor(Color("ColorButton"))
//                                            .fontWeight(.bold)
//                                            .font(.title3)
//                                    })
                                    
                                }
                                Spacer()
                            }
                            Spacer()
                            
                            
//                            HStack{
//                                NavigationLink( destination: RegisterView(), isActive: $showRegisterView) {
//                                    LandingButtonView(geometryWidth: geometry.size.width,
//                                                      geometryHeight: geometry.size.height,
//                                                      foregroundColor: Color(.white),
//                                                      backgroundColor: Color("ColorButton"),
//                                                      buttonText: CommonConstants.register.uppercased()){
//                                        self.showRegisterView = true
//                                    }
//                                }
//                            }
//                            HStack{
//                                NavigationLink( destination: LoginView(), isActive: $showLoginView){
//                                    LandingButtonView(geometryWidth: geometry.size.width,
//                                                      geometryHeight: geometry.size.height,
//                                                      foregroundColor: Color(.white),
//                                                      backgroundColor: Color("ColorButton"),
//                                                      buttonText: CommonConstants.login.uppercased()){
//                                        self.showLoginView = true
//                                    }
//                                }
//                            }
//                            HStack {
//                                Text("Version 1.0.0")
//                            }
                        }
                    }
                }
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
