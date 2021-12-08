//
//  Test_HomeServices.swift
//  kiliaroTests
//
//  Created by Emad Bayramy on 12/9/21.
//

import XCTest
@testable import kiliaro

final class HomeServicesTest: XCTestCase {
    
    var sut: HomeService?
    var ImagesJson: Data?
    
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "images", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.ImagesJson = data
            } catch {
                
            }
        }
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_getImages() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = ImagesJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = HomeService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async Images test")
        var images: HomeImagesModel?
        
        // When
        sut?.getImages(completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let image):
                images = image
            case .failure:
                XCTFail()
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(images?.count == 40)
    }
}


