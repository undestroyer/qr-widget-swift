protocol ScanProviderProtocol {
    func saveQr(content: String)
}

struct ScanProvider: ScanProviderProtocol {
    
    private let dataStore: SharedUserDefaultsServiceProtocol
    
    init (dataStore: SharedUserDefaultsServiceProtocol = SharedUserDefaultsService()) {
        self.dataStore = dataStore
    }
    
    func saveQr(content: String) {
        dataStore.saveQrContent(content)
    }
}
