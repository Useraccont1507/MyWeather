//
//  MyWeatherTests.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 31.01.2025.
//

import XCTest
@testable import MyWeather

class MockFirstView: FirstViewProtocol { }

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
    presenter.didTapButton(from: UIViewController())
    XCTAssertTrue(mockRouter.didCallPresentSearchView, "presenter didn't execute didTapButton")
  }
}
