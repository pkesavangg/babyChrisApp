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
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ZStack{
                    Color(.white)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack{
                            Image("Logo")
                                .resizable()
                                .frame(maxWidth: min(geometry.size.width, 200),
                                       maxHeight:min(geometry.size.width, 200))
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }.padding(.top,100)
                        Spacer()
                        VStack(spacing: 30) {
                            HStack{
                                NavigationLink( destination: RegisterView(), isActive: $showRegisterView) {
                                    LandingButtonView(geometryWidth: geometry.size.width,
                                                      geometryHeight: geometry.size.height,
                                                      foregroundColor: "ColorPrimary",
                                                      backgroundColor: "ColorPrimary",
                                                      buttonText: CommonConstants.register.uppercased()){
                                        self.showRegisterView = true
                                    }
                                }
                            }
                            HStack{
                                NavigationLink( destination: LoginView(), isActive: $showLoginView){
                                    LandingButtonView(geometryWidth: geometry.size.width,
                                                      geometryHeight: geometry.size.height,
                                                      foregroundColor: "ColorText",
                                                      backgroundColor: "ColorSecondary",
                                                      buttonText: CommonConstants.login.uppercased()){
                                        self.showLoginView = true
                                    }
                                }
                            }
                        }
                        Spacer()
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
