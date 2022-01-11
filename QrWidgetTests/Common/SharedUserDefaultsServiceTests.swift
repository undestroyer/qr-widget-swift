//
//  SharedUserDefaultsServiceTests.swift
//  QrWidgetTests
//
//  Created by Dmitriy Sazonov on 03.01.22.
//

import XCTest
@testable import QrWidget

class SharedUserDefaultsServiceSuccessTests: XCTestCase {
    var userDefaultsMock: UserDefaultsMock!
    var sut: SharedUserDefaultsService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userDefaultsMock = UserDefaultsMock()
        sut = SharedUserDefaultsService(sharedUD: userDefaultsMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        userDefaultsMock = nil
        try super.tearDownWithError()
    }

    func testGet() throws {
        // given
        let qrContent = "Hello world!"
        userDefaultsMock.stringToReturn = qrContent
        // when
        let qr = sut.getQrContent()
        // then
        XCTAssertEqual(qr, qrContent)
    }
    
    func testSet() throws {
        // given
        let qrContent = "Hello world!"
        // when
        sut.saveQrContent(qrContent)
        // then
        XCTAssertEqual(userDefaultsMock.stringToReturn, qrContent)
    }

}
