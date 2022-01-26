protocol HomeProviderProtocol {
    func getQr(completition: @escaping ([QrModel]) -> Void)
}

struct HomeProvider: HomeProviderProtocol {
    private let dataStore: SharedUserDefaultsServiceProtocol
    init (dataStore: SharedUserDefaultsServiceProtocol = SharedUserDefaultsService()) {
        self.dataStore = dataStore
    }
    
    func getQr(completition: @escaping ([QrModel]) -> Void) {
        completition(dataStore.getQrs())
    }
}
