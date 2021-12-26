//
//  ScanDataFlow.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 26.12.21.
//

enum Scan {
    // MARK: - Use cases
    enum StartScan {
        struct Request {}
        
        struct Response {
            var result: StartScanResult
        }
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum FoundQr {
        struct Request {
            var payload: String
        }
        
        struct Response {}
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum StartScanResult {
        case unknownIssue
        case permissionIssue
        case success
    }
    
    enum ViewControllerState {
        case loading
        case unknownError
        case permissionIssueOccured
        case started
        case finished
    }
}
