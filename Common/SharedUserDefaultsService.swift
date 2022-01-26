import Foundation
protocol SharedUserDefaultsServiceProtocol {
    func getQrs() -> [String]
    func saveQrContent(_ content: String)
}

struct SharedUserDefaultsService: SharedUserDefaultsServiceProtocol {
    
    init (sharedUD: UserDefaults? = UserDefaults(suiteName: UserDefaultsConstants.suiteId)) {
        self.sharedUD = sharedUD
    }
    
    private var sharedUD: UserDefaults?
    
    func getQrs() -> [String] {
        guard let sharedUD = sharedUD, let qrContent = sharedUD.string(forKey: UserDefaultsConstants.QR) else {
            return []
        }
        return [qrContent]
    }
    
    func saveQrContent(_ code: String) {
        guard let sharedUD = sharedUD else {
            return
        }
        
        sharedUD.set(code, forKey: UserDefaultsConstants.QR)
    }
    
    
}
