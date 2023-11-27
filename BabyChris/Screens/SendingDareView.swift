//
//  SendDareView.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 23/04/23.
//

import SwiftUI

struct SendingDareView: View {
    @ObservedObject var viewModel: MainViewModel
    @FocusState private var focus : FocusText?
    @State private var canShowChildName: Bool = false;
    var body: some View {
        VStack {
            List {
                if let childName = viewModel.currentUserDetails?.childName, viewModel.isGameStarted {
                    Section("Chris child details") {
                        HStack{
                            VStack(alignment: .leading){
                                Text("Child name")
                                    .fontWeight(.semibold)
                                Group {
                                    if(canShowChildName){
                                        TextField("Child name", text: .constant(childName))
                                    }else{
                                        SecureField("Child name", text: .constant(childName))
                                    }
                                }
                                .frame(height: 15)
                                .disabled(true)
                            }
                            Image(systemName: canShowChildName ? "eye.slash" : "eye" )
                                .onTapGesture {
                                    self.canShowChildName.toggle()
                                }
                        }
                    }
                    if !viewModel.isDareCompleted {
                        Section("Send dare message") {
                            TextArea("Enter dare message", text: $viewModel.dareMessage)
                            HStack{
                                Spacer()
                                Button {
                                    Task{
                                        await viewModel.sendDare()
                                        self.viewModel.dareMessage = ""
                                        focus = nil
                                    }
                                } label: {
                                    Text(viewModel.isDareAssignedAlready ? "UPDATE DARE" : "SEND DARE")

                                    
                                        .fontWeight(.bold)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(viewModel.dareMessage.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray: Color.blue)
                                        .opacity(viewModel.dareMessage.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5: 1)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                //.buttonStyle(.borderedProminent)
                                .disabled(viewModel.dareMessage.trimmingCharacters(in: .whitespaces).isEmpty)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 05, leading: 0, bottom: 05, trailing: 0))
                        }
                        .listRowSeparator(.hidden)
                    }
                    
                    Section(header: Text("Dare Completion Status")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Dare Completed", isOn: $viewModel.isDareCompleted)
                                .onChange(of: viewModel.isDareCompleted) { isDareCompleted in
                                    Task {
                                            await self.viewModel.sendDareCompletionStatus(isDareCompleted)
                                        }
                                }
                            Text("Note: Please mark this toggle if your child has successfully completed the assigned dare.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                if(!viewModel.isGameStarted){
                    Section("Game status"){
                        Spacer()
                        VStack{
                            HStack{
                                Spacer()
                                Text("Game has not yet started.")
                                    .bold()
                                    .font(.title2)
                                Spacer()
                            }
                        }
                        .listRowSeparator(.hidden)
                        Spacer()
                    }
                }
            }
        }
        .resignOnDrag()
    }
}

struct TextArea: View {
    private let placeholder: String
    @Binding var text: String
    @FocusState private var focus : FocusText?
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    var body: some View {
        TextEditor(text: $text)
            .background(
                VStack{
                    HStack(alignment: .top) {
                        text.isEmpty ? Text(placeholder) : Text("")
                        Spacer()
                    }
                    Spacer()
                }
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 08, leading: 5, bottom: 7, trailing: 0))
            )
            .disableAutocorrection(true)
            .focused($focus , equals: .dareMessage)
            .frame(height: 200)
    }
}
