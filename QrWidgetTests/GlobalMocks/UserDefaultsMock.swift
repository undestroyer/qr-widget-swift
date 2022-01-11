import Foundation

class UserDefaultsMock: UserDefaults {
    
    var stringToReturn: String? = nil
    
    override func string(forKey defaultName: String) -> String? {
        return stringToReturn
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        stringToReturn = value as? String
    }
}
