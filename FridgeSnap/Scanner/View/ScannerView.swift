import SwiftUI
import AVFoundation



struct ScannerView: UIViewControllerRepresentable {
   
    var onCodeScanned: (String) -> Void  // Closure, der aufgerufen wird, wenn ein Code gescannt wird
    
    func makeUIViewController(context: Context) -> ScannerController {
        let viewController = ScannerController()
        viewController.onCodeScanned = onCodeScanned
        return viewController
    }

    func updateUIViewController(_ uiViewController: ScannerController, context: Context) {
        // Hier könnten Updates für den ViewController hinzugefügt werden, falls nötig
    }
}



// SwiftUI Preview
struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(onCodeScanned: {x in print(x)})
    }
}
