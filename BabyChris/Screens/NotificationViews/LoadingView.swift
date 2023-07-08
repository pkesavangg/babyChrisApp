//
//  LoadingView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 08/04/23.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    @Binding var loaderText: String
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    HStack{
                        ProgressView()
                            .tint(Color("ColorSecondary"))
                            .padding(.trailing, 10)
                        Text(loaderText)
                            .foregroundColor(Color("ColorSecondary"))
                    }
                }
                .frame(height: geometry.size.height / 15)
                .padding(.leading)
                .padding(.trailing)
                .background(Color(.white))
                .foregroundColor(Color("ColorSecondary"))
                .cornerRadius(5)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}

//For testing purpose to view the loader in preview.
struct LoaderTestingView: View {
    var isLoading = true
    var loaderMessge =  "Loading"
    @State var searchText = ""
    var body: some View{
        LoadingView(isShowing: .constant(isLoading), loaderText: .constant(loaderMessge)) {
            NavigationView {
                List( [1,2,3,4,5,6,7,8,9,10,11] , id: \.self ) { element in
                    Text("\(element)")
                }.navigationTitle("Testing View")
                    .searchable(text: $searchText, prompt: "StringProtocol")
            }
        }
    }
}

struct LoaderTestingView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderTestingView()
    }
}
