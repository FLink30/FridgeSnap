//
//  AmountPickerView.swift
//  FridgeSnap
//
//  Created by Franziska Link on 07.01.24.
//

import SwiftUI

struct AmountPickerView: View {
    @State private var selectedUnit: String = "Items"
    @State private var amount: Int = 1

    let units = ["Items", "Kilograms", "Liters"]

    var body: some View {
        VStack {
            Picker("Unit", selection: $selectedUnit) {
                ForEach(units, id: \.self) { unit in
                    Text(unit)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Stepper(value: $amount, in: 1...100) {
                Text("Amount: \(amount)")
            }
            .padding()

            Text("Selected Unit: \(selectedUnit)")
        }
    }
}

struct AmountPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AmountPickerView()
    }
}
