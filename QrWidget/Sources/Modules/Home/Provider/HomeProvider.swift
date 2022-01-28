protocol HomeProviderProtocol {
    func getQr(completition: @escaping ([QrModel]) -> Void)
}

struct HomeProvider: HomeProviderProtocol {
    private let dataStore: CoreDataServiceProtocol
    init (dataStore: CoreDataServiceProtocol = CoreDataService.shared) {
        self.dataStore = dataStore
    }
    
    func getQr(completition: @escaping ([QrModel]) -> Void) {
        completition(dataStore.fetchQrCodes())
    }
}
