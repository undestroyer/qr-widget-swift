//
//  QrGenerator.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 20.12.21.
//

import UIKit
import CoreImage.CIFilterBuiltins

protocol QrGeneratorProtocol {
    func generateQRCode(content: String) -> UIImage
}

class QrGenerator: QrGeneratorProtocol {
    func generateQRCode(content: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(content.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 5, y: 5)
        
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "qrcode") ?? UIImage()
    }
}
