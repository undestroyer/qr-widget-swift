import Foundation

protocol SharedUserDefaultsServiceProtocol {
    func getQrs() -> [QrModel]
    func saveQrContent(_ content: String)
}

struct SharedUserDefaultsService: SharedUserDefaultsServiceProtocol {
    
    init (sharedUD: UserDefaults? = UserDefaults(suiteName: UserDefaultsConstants.suiteId)) {
        self.sharedUD = sharedUD
    }
    
    private var sharedUD: UserDefaults?
    
    func getQrs() -> [QrModel] {
        guard let sharedUD = sharedUD,
                let qrContent = sharedUD.string(forKey: UserDefaultsConstants.QR) else {
            return []
        }
        return [QrModel(id: "1", name: "Demo name", content: qrContent)]
    }
    
    func saveQrContent(_ code: String) {
        guard let sharedUD = sharedUD else {
            return
        }
        
        sharedUD.set(code, forKey: UserDefaultsConstants.QR)
    }
    
    func removeQR() {
        guard let sharedUD = sharedUD else {
            return
        }
        sharedUD.removeObject(forKey: UserDefaultsConstants.QR)
    }
}
