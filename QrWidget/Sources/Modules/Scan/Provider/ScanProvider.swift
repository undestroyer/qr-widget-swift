import Foundation
protocol ScanProviderProtocol {
    func saveQr(content: String)
}

struct ScanProvider: ScanProviderProtocol {
    
    private let dataStore: CoreDataServiceProtocol
    
    init (dataStore: CoreDataServiceProtocol = CoreDataService.shared) {
        self.dataStore = dataStore
    }
    
    func saveQr(content: String) {
        dataStore.insertQrCode(QrModel(id: "", name: "Qr code", content: content))
    }
}
