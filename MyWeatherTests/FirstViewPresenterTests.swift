//
//  MyWeatherTests.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 31.01.2025.
//

import XCTest
@testable import MyWeather

class MockFirstView: FirstViewProtocol {
  var didCallShowGreeting = false
  var receivedMainText: String?
  var receivedSecondaryText: String?
  var receivedImage: UIImage?
  var receivedButtonText: String?
  
  func showGreeting(mainText: String, secondaryText: String, image: UIImage, buttonText: String) {
    didCallShowGreeting = true
    receivedMainText = mainText
    receivedSecondaryText = secondaryText
    receivedImage = image
    receivedButtonText = buttonText
  }
}

final class FirstViewPresenterTests: XCTestCase {
  var presenter: FirstViewPresenter!
  var mockView: MockFirstView!
  var mockRouter: MockRouter!
  
  override func setUpWithError() throws {
    mockView = MockFirstView()
    mockRouter = MockRouter(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
    presenter = FirstViewPresenter(view: mockView, router: mockRouter)
  }
  
  override func tearDownWithError() throws {
    mockView = nil
    presenter = nil
    mockRouter = nil
  }
  
  func testExample() throws {
    presenter.prepareGreeting()
    XCTAssertTrue(mockView.didCallShowGreeting, "Method showGreeting wasn't called")
    XCTAssertEqual(mockView.receivedMainText, "main_greeting".localized)
    XCTAssertEqual(mockView.receivedSecondaryText, "secondary_greeting".localized)
    XCTAssertEqual(mockView.receivedButtonText, "select_button_text".localized)
    XCTAssertNotNil(mockView.receivedImage)

    presenter.didTapButton(from: UIViewController())
    XCTAssertTrue(mockRouter.didCallPresentSearchView, "presenter didn't execute didTapButton")
  }
}
