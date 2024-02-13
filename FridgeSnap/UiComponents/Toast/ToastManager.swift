import SwiftUI

class ToastManager: ObservableObject {
    @Published var toastVisible: Bool = false
    @Published var toastType: ToastStyle = .error //default
    @Published var toastTitle: String = ""
    @Published var toastMessage: String = ""
    
    func show(type: ToastStyle) {
        toastType = type
        setToastContent()
        
        toastVisible = true
        
        //after 2 sec going to wanish
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.toastVisible = false
            }
        }
    }
    
    private func setToastContent() {
        switch toastType {
        case .info:
            toastTitle = "No name!"
            toastMessage = "Your product need a name."
        case .warning:
            toastTitle = "Already added!"
            toastMessage = "Product is already in your list."
        case .success:
            toastTitle = "Saved!"
            toastMessage = "Product is saved in your list."
        case .error:
            toastTitle = "Error!"
            toastMessage = "Product is not saved."
        case .delete:
            toastTitle = "Deleted!"
            toastMessage = "Product deleted."
        case .deleteList:
            toastTitle = "Deleted!"
            toastMessage = "List deleted."

        }
    }
}
