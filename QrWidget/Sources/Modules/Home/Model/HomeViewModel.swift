import UIKit
struct HomeViewModel {
    let qrs: [HomeQrViewModel]
}

struct HomeQrViewModel {
    let id: String
    let image: UIImage
    let name: String
}
