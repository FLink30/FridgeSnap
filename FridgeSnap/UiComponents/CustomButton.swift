import Foundation
import SwiftUI

struct CustomButton: View{
    // Type, Title, Disabled, Image, Action  /////////////////////////
    var type: ButtonType
    var title: String?
    var disabled: Bool
    var image: String?
    var action: (() -> ())?
    
    // Colors  /////////////////////////
    var textColor: Color {
        switch type {
        case .filled:
            if disabled {
                return .gray
            } else {
                return .white
            }
        case .bordered, .plain, .icon:
            if disabled {
                return .gray
            } else {
                return .blue
            }
        }
        
    }
    
    // For the future /////////////////////////
    var backgroundColor: Color {
        switch type {
        case .filled:
            if disabled {
                return .gray.opacity(0.3)
            } else {
                return .blue
            }
        case .bordered, .plain, .icon:
            return .clear
        }
    }
    
    // Body  /////////////////////////
    var body: some View {
        // depending on InputType modified Text or Image /////////////////////////
        switch type {
        case .bordered, .plain, .filled:
            // depending on action with onTapGesture /////////////////////////
            if let action {
                Text(title ?? "")
                    .textModifiers(type: type,
                                   textColor: textColor,
                                   backgroundColor: backgroundColor)
                .onTapGesture {
                    action()
                }
            } else {
                Text(title ?? "")
                    .textModifiers(type: type,
                                   textColor: textColor,
                                   backgroundColor: backgroundColor)
            }
        case .icon:
            if let action {
                Image(systemName: image ?? "")
                    .buttonModifiers(type: .icon,
                                     textColor: textColor,
                                     backgroundColor: backgroundColor)
                .onTapGesture {
                    action()
                }
            } else {
                Image(systemName: image ?? "")
                    .buttonModifiers(type: .icon,
                                     textColor: textColor,
                                     backgroundColor: backgroundColor)
            }
        }
        
    }
}

// Text and Image extension /////////////////////////
fileprivate extension Text {
    func textModifiers(type: ButtonType, textColor: Color, backgroundColor: Color) -> some View {
        switch type {
        case .filled:
            return AnyView(
                self
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(Padding.small())
                    .frame(minWidth: Padding.buttonWidth(), minHeight: Padding.buttonHeight())
                    .background(backgroundColor)
                    .clipShape(Capsule())
            )
        case .bordered:
            return AnyView(
                self
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(Padding.small())
                    .frame(minWidth: Padding.buttonWidth(), minHeight: Padding.buttonHeight())
                    .background(Capsule()
                        .fill(backgroundColor)
                        .stroke(textColor, style: StrokeStyle(lineWidth: 2)))
            )
        case .plain:
            return AnyView(
                self
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(Padding.small())
                    .frame(minWidth: Padding.medium(), minHeight: Padding.buttonHeight())
            )
        default :
            return AnyView(
                self
            )
        }
    }
}

fileprivate extension Image {
    func buttonModifiers(type: ButtonType, textColor: Color, backgroundColor: Color) -> some View {
        switch type {
        case .icon:
            return AnyView(
                self
                    .padding(Padding.small())
                    .frame(minWidth: Padding.large(), minHeight: Padding.buttonHeight())
                    .foregroundColor(textColor)
            )
        default:
            return AnyView(
                self
            )
        }
    }
}



#Preview {
    VStack {
        CustomButton(type: .filled, title: "Test",  disabled: true) {
        }
        
        CustomButton(type: .plain, title: "Test", disabled: true) {
        }
        
        CustomButton(type: .bordered, title: "Test", disabled: true, action: {
            
        })
        CustomButton(type: .icon, disabled: true, image: "chevron.forward", action: {
            
        })
    }
}
