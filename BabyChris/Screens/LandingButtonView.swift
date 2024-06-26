//
//  LandingButtonView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 31/03/23.
//

import SwiftUI

struct LandingButtonView: View {
    var geometryWidth: CGFloat
    var geometryHeight: CGFloat
    var foregroundColor: Color
    var backgroundColor: Color
    var buttonText: String
    let buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction) {
            Text(buttonText)
                .foregroundColor(foregroundColor)
                .clipShape(Capsule())
                .frame( width: geometryWidth > CGFloat(minScreenWidth)  ?  geometryWidth *  0.7 : geometryWidth *  0.8,
                        height: geometryWidth > CGFloat(minScreenWidth) ? geometryHeight * 0.09 : geometryHeight * 0.09)
                .background(backgroundColor)
                .cornerRadius(geometryWidth > CGFloat(minScreenWidth) ? geometryWidth * 0.8 :geometryWidth * 0.5)
                .font(.system(size: geometryWidth > CGFloat(minScreenWidth) ? 50: 30))
                .minimumScaleFactor(0.5)
        }
    }
}
