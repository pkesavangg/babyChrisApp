//
//  ToastView.swift
//  perfectportions
//
//  Created by Kesavan Panchabakesan on 10/02/23.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    
    struct ToastData {
        var title:String
        var detail: String?
        var type: ToastType
        var buttonText: Text?
        var onClick: ()->() = { }
    }
    
    enum ToastType {
        case Info
        case Warning
        case Success
        case Error
        
        var tintColor: Color {
            switch self {
            case .Info:
                return Color(.systemTeal)
            case .Success:
                return Color("ColorSecondary")
            case .Warning:
                return Color.yellow
            case .Error:
                return Color("ColorDanger")
            }
        }
    }
    
    // Members for the ToastModifier
    @Binding var data:ToastData
    @Binding var show:Bool?
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var timer: DispatchSourceTimer?
    var duration: Double
    func body(content: Content) -> some View {
        
        ZStack {
            content
            if let showValue = show{
                if showValue {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(data.title)
                                    .font(Font.system(size: 15, weight: Font.Weight.semibold, design: Font.Design.default )).foregroundColor(Color(.black))
                                Text(data.detail ?? "" )
                                    .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default)).foregroundColor(Color(.black))
                            }
                            Spacer()
                            if self.data.buttonText != nil {
                                Button {
                                    self.data.onClick()
                                    withAnimation{
                                        self.show = false
                                    }
                                    self.timer?.cancel()
                                    self.timer = nil
                                } label: {
                                    data.buttonText
                                        .foregroundColor(Color("ColorPrimary"))
                                        .padding(.trailing,5)
                                }
                            }
                        }
                        
                        .foregroundColor(Color("ColorLight"))
                        .padding(12)
                        .background(data.type.tintColor)
                        .cornerRadius(15)
                        .frame(width: min(UIScreen.screenWidth * 0.9, 500))
                        .offset(x: offset.width, y: 0)
                        Spacer()
                    }
                    
                    .padding()
                    .transition(AnyTransition.move(edge: .top)
                        .combined(with: .opacity))
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            withAnimation {
                                self.offset.width = gesture.translation.width
                                self.isDragging = true
                            }
                        }
                        .onEnded { gesture in
                            withAnimation{
                                self.show = false
                                self.offset.width = 0
                                self.isDragging = false
                            }
                            // Cancel the timer when the toast is dismissed
                            self.timer?.cancel()
                            self.timer = nil
                        })
                    /* The code belows used for remove the toast by tap on that currently we remove the toast by drag gesture */
                    
                    //                    .onTapGesture {
                    //                        withAnimation {
                    //                            self.show = false
                    //                        }
                    //                    }
                    .onAppear(perform: {
                        let timer = DispatchSource.makeTimerSource()
                        timer.schedule(deadline: .now() + duration)
                        timer.setEventHandler {
                            DispatchQueue.main.async {
                                withAnimation {
                                    self.show = false
                                }
                            }
                        }
                        timer.resume()
                        self.timer?.cancel()
                        self.timer = nil
                        // Keep a reference to the timer and cancel it when the toast is dismissed
                        self.timer = timer
                    })
                }
            }
        }
    }
    
}

extension View {
    func showToast(data: Binding<ToastModifier.ToastData>, show: Binding<Bool?>, duration: Double = 3) -> some View {
        self.modifier(ToastModifier(data: data, show: show, duration: duration))
    }
}

//For testing purpose to view the toast in preview

struct ToastTestingView : View{
    @StateObject var viewModel = ToastViewModel()
    @State var showToast:Bool?
    @State var toastData: ToastModifier.ToastData = ToastModifier.ToastData(title: "",  type: .Info)
    @State var toggle = false
    var body: some View{
        VStack{
            Button {
                if (toggle){
                    self.toastData.title = "ToastMessages.loginError"
                    self.toastData.detail = "ToastMessages.emailAlreadyExist"
                }else{
                    self.toastData.title = "ToastMessages.loginSuccess"
                    self.toastData.detail = "ToastMessages.successfullyRegistered"
                }
                self.toggle.toggle()
                self.toastData.type = .Success
                self.toastData.buttonText = Text("\("LOG IN") \(Image(systemName: "arrow.right")) ")
                self.toastData.onClick = viewModel.handleButtonClick
                self.showToast = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(Animation.spring()) {
                        self.showToast = true
                    }
                }
            } label: {
                Text("Login").foregroundColor(.green)
            }
        }.showToast(data: $toastData, show: $showToast)
        
    }
}

class ToastViewModel : ObservableObject {
    func handleButtonClick() {
        print("handleButtonClick")
    }
}


struct ToastTestingView_Previews: PreviewProvider {
    static var previews: some View {
        ToastTestingView()
    }
}
