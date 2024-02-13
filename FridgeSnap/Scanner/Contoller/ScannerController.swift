//
//  ScannerViewController.swift
//  FridgeSnap
//
//  Created by Franziska Link on 18.01.24.
//

import Foundation
import AVFoundation
import UIKit
import os


class ScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var onCodeScanned: ((String) -> Void)?
    var logger = Logger()

    override func viewDidLoad() {

        super.viewDidLoad()
        logger.notice("View did load")
        
        // Hintergrundfarbe setzen
        view.backgroundColor = UIColor.black
        
        // CaptureSession stellt die Kamerafunktionen bereit
        captureSession = AVCaptureSession()
        logger.notice("captureSession built")
        
        // Kamera suchen
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {  logger.warning("guard failed"); return }
        let videoInput: AVCaptureDeviceInput
        logger.notice("got Videocapturedevice")
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            logger.error("No Camera found")
            return
        }
        // Kamera der CaptureSession als Input hinzufügen
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        //gescannter Code = metadaten. Dafür einen MetadataOutput-Objekt anlegen und der CaptureSession als Output hinzufügen
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417] //Barcodetypen, die unsere App lesen können soll
        } else {
            failed()
            return
        }
        // Kamera-PreviewLayer als Sublayer des Views mit erstellen
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // CaptureSession starten
        captureSession.startRunning()
    }
    
    // Fehlermeldung, wenn aus irgendeinem Grund das Scannen nicht möglich ist.
    func failed() {
        // Alert erstellen
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default)) // nur Ok als einzige Option
        present(ac, animated: true) // Alert mit Animation anzeigen
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // CaptureSession wieder starten, wenn View wieder erscheint
        if (captureSession?.isRunning == false) {
                captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // CaptureSession anhalten, wenn View verschwindet
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    // Funktion, die bei neuem MetadataOutput aufgerufen wird, also wenn ein Code im Bild gefunden
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning() // CaptureSession anhalten
        
        // erstes Metadaten-Objekt anschauen
        if let metadataObject = metadataObjects.first {
            // Prüfen, ob tatsäclich ein Barcode gefunden wurde
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            // Prüfen, ob es ein String ist
            guard let stringValue = readableObject.stringValue else { return }
            // User Feedback per Vibration geben
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            // Code verarbeiten
            found(code: stringValue)
        }
        // View mit Animation schließen
        dismiss(animated: true)
    }

    // Verarbeitungsfunktion. Einfach den gescannten Code an die Closure übergeben.
    func found(code: String) {
        print(code)
        onCodeScanned?(code)
        dismiss(animated: true)
    }

    // View soll keine Statusbar anzeigen
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // Nur im Portrait-Modus verwenden
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
