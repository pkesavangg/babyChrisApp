//
//  ViewExtensions.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 08/04/23.
//

import SwiftUI

extension View {
    //To hide the keyboard view.
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    //Hide the keyboard when the user drags on the view.
    func resignOnDrag() -> some View {
        return self.gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
    }
    
}

// Sets the background color and title color of the navigation bar using the given background color and title color values.
func setNavigationBarBackgroundColor(backgroundColor: UIColor, titleColor: UIColor){
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithTransparentBackground()
    coloredAppearance.backgroundColor = backgroundColor
    coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
}
