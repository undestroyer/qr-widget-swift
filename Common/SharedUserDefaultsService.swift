import Foundation
protocol SharedUserDefaultsServiceProtocol {
    func getQrContent() -> String?
    func saveQrContent(_ content: String)
}

struct SharedUserDefaultsService: SharedUserDefaultsServiceProtocol {
    private var sharedUD: UserDefaults? { UserDefaults(suiteName: UserDefaultsConstants.suiteId) }
    
    func getQrContent() -> String? {
        guard let sharedUD = sharedUD else {
            return nil
        }
        return sharedUD.string(forKey: UserDefaultsConstants.QR)
    }
    
    func saveQrContent(_ code: String) {
        guard let sharedUD = sharedUD else {
            debugPrint("Failed to save QR content in User Defaults")
            return
        }
        
        sharedUD.set(code, forKey: UserDefaultsConstants.QR)
    }
    
    
}
