//
//  CityControlPresenterTest.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 02.02.2025.
//

import XCTest
@testable import MyWeather

class MockCityControlView: CityViewControlProtocol {
  var isChangePageCalled = false
  func setPresenter(presenter: MyWeather.CityPageControlPresenter) { }
  
  func preparePageControl(initialPage: UIViewController?, numberOfPages: Int, currentPage: Int) { }
  
  func changeCurrentPage(pages: [UIViewController], direction: UIPageViewController.NavigationDirection) {
    isChangePageCalled = true
  }
}

class CityPageControlPresenterTest: XCTestCase {
  var router: MockRouter!
  var view: MockCityControlView!
  var presenter: CityPageControlPresenterProtocol!
  var webManager: MockWebManager!
  var storage: MockStorage!
  var backgroundManager: MockBackgroundManager!
  
  
  override func setUpWithError() throws {
    router = MockRouter(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
    view = MockCityControlView()
    webManager = MockWebManager()
    backgroundManager = MockBackgroundManager()
    storage = MockStorage()
    presenter = CityPageControlPresenter(
      router: router,
      view: view,
      storage: storage,
      pageindex: 1
    )
  }
  
  override func tearDownWithError() throws {
    router = nil
    view = nil
    presenter = nil
    webManager = nil
    backgroundManager = nil
  }
  
  func testGetPageIndex() {
    XCTAssertEqual(presenter.getPageIndex(), 1)
  }
  
  func testChangePageIndex() {
    presenter.changePageIndex(index: 2)
    XCTAssertEqual(2, presenter.getPageIndex())
  }
  
  func testChangePage() {
    presenter.changePage(newPageIndex: 0)
    XCTAssertTrue(view.isChangePageCalled)
  }
  
  func testMoveToRootView() {
    presenter.moveToRootView()
    XCTAssertTrue(router.isCallMoveToCitiesList)
  }
}
