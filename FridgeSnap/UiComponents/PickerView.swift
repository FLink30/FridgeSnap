//
//  PickerView.swift
//  FridgeSnap
//
//  Created by Franziska Link on 21.01.24
//


import SwiftUI

// generic Picker ////////////////////////////////////////
struct PickerView<T: Hashable & CaseIterable & PickerData>: View where T.AllCases == [T] {
    @Environment(\.presentationMode) var presentationMode
    @Binding private var selectedItem: T
    let settingName: LocalizedStringKey
    
    init(selectedItem: Binding<T>) {
        self._selectedItem = selectedItem
        self.settingName = LocalizedStringKey("Picker")
    }
    

    var body: some View {
        NavigationView {
            VStack(alignment: .trailing, spacing: Padding.prettyPrettySmall()) {
                Picker(selection: $selectedItem, label: Text(settingName)) {
                    ForEach(T.allCases, id: \.self) { item in
                        Text(item())
                    }
                }.pickerStyle(.wheel)
                
                // Toolbar ////////////////////////////////////////
            }.toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    CustomButton(type: .plain, title: "Done", disabled: false) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct PickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView<Category>(selectedItem: .constant(Category.vegetables))
    }
}



