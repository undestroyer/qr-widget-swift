import Foundation
protocol SharedUserDefaultsServiceProtocol {
    func getQrContent() -> String?
    func saveQrContent(_ content: String)
}

struct SharedUserDefaultsService: SharedUserDefaultsServiceProtocol {
    
    init (sharedUD: UserDefaults? = UserDefaults(suiteName: UserDefaultsConstants.suiteId)) {
        self.sharedUD = sharedUD
    }
    
    private var sharedUD: UserDefaults?
    
    func getQrContent() -> String? {
        guard let sharedUD = sharedUD else {
            return nil
        }
        return sharedUD.string(forKey: UserDefaultsConstants.QR)
    }
    
    func saveQrContent(_ code: String) {
        guard let sharedUD = sharedUD else {
            return
        }
        
        sharedUD.set(code, forKey: UserDefaultsConstants.QR)
    }
    
    
}
