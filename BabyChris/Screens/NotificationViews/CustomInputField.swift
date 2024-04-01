import SwiftUI

/**
 This is a custom input field view that can be used to create a text field with various customizable properties.
 The view also provides callback functions for editing changes and for when the user hits the return key on the keyboard.
 */

enum InputType {
    case text, password, email
}

struct InputField: View {
    //PROPERTIES
    var inputType: InputType
    @State var isSecureField = true
    @State var showPasswordEyeIcon : Bool = false
    @Binding var value: String
    var placeholder: String
    var textFieldLabel: String
    var fontName: String = "OpenSans-Regular"
    var fontSize: CGFloat = 18
    var fontColor: Color = Color(.lightGray)
    var foregroundColor: Color?
    var disableAutoCorrection: Bool = true
    var autoCapitalization: Bool = true
    var errorMessage : String
    var passwordMatchingErrorMessage : String?
    
    var editingChanged: (Bool)->() = { _ in } //Whenever the user changes the field it turn to true.
    var commit: ()->() = { } //Similar to on submit it triggers when user hit return in keyboard.
    var onEditEnd: ()->() = { }
    var body: some View {
        ZStack(alignment: .leading) {
            VStack (alignment: .leading){
                Text("\(textFieldLabel)")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.bottom)
                Group {
                    HStack{
                        if(isSecureField && inputType == InputType.password){
                            CustomSecureTextField(text: $value, placeholder: "\(placeholder)") {
                                commit()
                            }onEditingChanged: { isEditing in
                                editingChanged(isEditing)
                            }
                        }else{
                            TextField("\(placeholder)", text: $value, onEditingChanged: editingChanged, onCommit: commit)
                        }
                        if inputType == InputType.password {
                            Image(systemName:  showPasswordEyeIcon ? "eye.fill" : "eye.slash.fill")
 //                               .resizable()
//                                .frame(width: 20, height: 20)
                                .accentColor(.gray)
                                .padding(.trailing, 10)
                                .onTapGesture {
                                    self.showPasswordEyeIcon.toggle()
                                    self.isSecureField.toggle()
                                }
                        }
                    }
                }
                .frame(height: 10)
                .keyboardType(inputType == InputType.email ? .emailAddress : .default)
                .disableAutocorrection(disableAutoCorrection)
                .autocapitalization((inputType == InputType.email ||  inputType == InputType.password) ? .none : .words)
                .foregroundColor((foregroundColor != nil) ?  foregroundColor : Color.primary)
                .textContentType(.emailAddress)
                Divider()
                    .frame(height: 0.5)
                    .background((!errorMessage.isEmpty || (passwordMatchingErrorMessage?.isEmpty == false)) ? Color("ColorDanger") : Color("ColorBorder"))
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(Color("ColorDanger"))
                    .frame(height: 10)
                if let error = passwordMatchingErrorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(Color("ColorDanger"))
                        .frame(height: 10)
                }
            }
        }
    }
}



import SwiftUI

struct CustomSecureTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onCommit: () -> Void
    var onEditingChanged: (Bool)->() = { _ in }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = placeholder
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textDidChange), for: .editingChanged)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.editingDidBegin), for: .editingDidBegin)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.editingDidEnd), for: .editingDidEnd)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.commitAction), for: .editingDidEndOnExit)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onCommit: onCommit, onEditingChanged: onEditingChanged)
    }
    
    class Coordinator: NSObject {
        @Binding var text: String
        var onCommit: () -> Void
        var onEditingChanged: (Bool)->() = { _ in }
        
        init(text: Binding<String>, onCommit: @escaping () -> Void, onEditingChanged: @escaping (Bool)->() = { _ in }) {
            _text = text
            self.onCommit = onCommit
            self.onEditingChanged = onEditingChanged
        }
        
        @objc func textDidChange(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        @objc func editingDidBegin() {
            // Called when editing begins
            onEditingChanged(true)
        }
        
        @objc func editingDidEnd() {
            // Called when editing ends
            onEditingChanged(false)
        }
        
        @objc func commitAction() {
            // Called when user hit return in keyboard
            onCommit()
        }
        
        
    }
}
