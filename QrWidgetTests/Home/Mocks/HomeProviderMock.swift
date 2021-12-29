@testable import QrWidget

class HomeProviderMock: HomeProviderProtocol {
    var returnValue: String? = nil
    func getQr(completition: @escaping (String?) -> Void) {
        completition(returnValue)
    }
}
