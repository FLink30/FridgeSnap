//
//  PickerView.swift
//  FridgeSnap
//
//  Created by Franziska Link on 15.12.23.
//

import SwiftUI

struct AmountUnitPickerView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode

    @Binding var pickerAmount: Int
    @Binding var pickerUnit: Unit

    let settingName: LocalizedStringKey = "Picker"

    private var amountList: [Int] {
        switch pickerUnit {
        case .count:
            return Array(1...10)
        case .gram:
            return Array(stride(from: 50, through: 1000, by: 50))
        case .kilogram:
            return Array(1...10)
        case .mililiter:
            return Array(stride(from: 250, through: 2000, by: 250))
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .trailing, spacing: Padding.prettySmall()) {

                // Unit Picker /////////////////////////////////////////////

                Picker(selection: $pickerUnit, label: Text(settingName)) {
                    ForEach(Unit.allCases, id: \.self) { unit in
                        Text(unit())
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(Padding.large())

                // Amount Picker ///////////////////////////////////////////

                Picker(selection: $pickerAmount, label: Text(settingName)) {
                        ForEach(amountList, id: \.self) { number in
                            switch pickerUnit {
                            case .count:
                                Text("\(number) \(pickerUnit.abbr())")
                            case .gram, .kilogram:
                                Text("\(number) \(pickerUnit.abbr())")
                            case .mililiter:
                                Text("\(format(number: number)) \(pickerUnit.abbr())")
                            }
                        }
                    }.pickerStyle(.wheel)
            }.toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    CustomButton(type: .plain, title: "Done", disabled: false) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    // Format for the floating numbers ///////////////////////////

    func format(number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        AmountUnitPickerView(pickerAmount: .constant(3), pickerUnit:.constant(Unit.count))
    }
}
