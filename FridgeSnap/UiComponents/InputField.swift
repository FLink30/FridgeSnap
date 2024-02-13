//
//  InputField.swift
//  FridgeSnap
//
//  Created by Franziska Link on 07.01.24.
//

import Foundation
import SwiftUI

struct InputField: View {
    
    @Binding var text: String
    var placeholder: String
    @FocusState var isFocused: InputType?
    var fieldType: InputType
    
    var body: some View {
        TextField(placeholder, text: $text)
            .border(Color.clear, width: 1)
            .focused($isFocused, equals: fieldType)
            .padding(Padding.medium())
    }
}


#Preview {
    @State var inputText = ""
    return InputField(text: $inputText,
                      placeholder: "Amount",
                      fieldType: .amount)
}
