@testable import QrWidget
import UIKit

class QrGeneratorMock: QrGeneratorProtocol {
    var isGenerateQRCodeCalled = false
    func generateQRCode(content: String) -> UIImage {
        isGenerateQRCodeCalled = true
        return UIImage()
    }
}
