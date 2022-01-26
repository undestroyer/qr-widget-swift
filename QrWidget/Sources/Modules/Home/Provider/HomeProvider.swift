protocol HomeProviderProtocol {
    func getQr(completition: @escaping ([String]) -> Void)
}

struct HomeProvider: HomeProviderProtocol {
    private let dataStore: SharedUserDefaultsServiceProtocol
    init (dataStore: SharedUserDefaultsServiceProtocol = SharedUserDefaultsService()) {
        self.dataStore = dataStore
    }
    
    func getQr(completition: @escaping ([String]) -> Void) {
        completition(dataStore.getQrs())
    }
}
