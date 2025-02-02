//
//  SearchCityViewPresenter.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 31.01.2025.
//

import XCTest
@testable import MyWeather

class MockSearchView: SearchCityViewProtocol {
  var isAlertPrepared = false
  var isTableViewReloaded = false
  var alertActionHandler: ((UIAlertAction) -> Void)?
  
  func prepareAlert(title: String, message: String, cancelTitle: String, actionHandler: @escaping (UIAlertAction) -> ()) {
    isAlertPrepared = true
    alertActionHandler = actionHandler
  }
  
  func reloadTableView() {
    isTableViewReloaded = true
  }
}

final class SearchCityViewPresenterTests: XCTestCase {
  var view: MockSearchView!
  var router: MockRouter!
  var presenter: SearchCityViewPresenter!
  var storage: MockStorage!
  var webManager: MockWebManager!
  var citiesCooordinatesModel: MockCitiesCoordinatesModel!
  
  override func setUpWithError() throws {
    view = MockSearchView()
    router = MockRouter(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
    webManager = MockWebManager()
    storage = MockStorage()
    citiesCooordinatesModel = MockCitiesCoordinatesModel()
    presenter = SearchCityViewPresenter(view: view, router: router, webManager: webManager, storage: storage, citiesCoordinatesModel: citiesCooordinatesModel)
  }
  
  override func tearDownWithError() throws {
    view = nil
    router = nil
    webManager = nil
    storage = nil
    citiesCooordinatesModel = nil
    presenter = nil
  }
  
  func testFetchingAndStorage() throws {
    presenter.searchTextDidChange(text: "bar")
    let expectation = XCTestExpectation(description: "Wait for city data to be fetched")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 5.0)
    
    XCTAssertEqual(presenter.getNumberOfItems(), 1, "City data wasn't updated")
    
    XCTAssertTrue(webManager.isFetchingCityCoordinatesCalled, "fetchCityCoordinates didn't called")
    XCTAssertEqual(webManager.mockCityData[0].name, presenter.getResult(for: 0)?.name)
    XCTAssertTrue(view.isTableViewReloaded, "tableView wasn't reloaded")
    
    XCTAssertEqual(presenter.getNumberOfItems(), 1)
    
    presenter.didTapOnCity(index: 0, from: UIViewController())
    XCTAssertTrue(view.isAlertPrepared, "alert wasn't prepared")
    
    if let actionHandler = view.alertActionHandler {
      actionHandler(UIAlertAction())
    }
    
    XCTAssertTrue(citiesCooordinatesModel.isAddingCalled, "adding to model wasn't called")
    
    XCTAssertTrue(router.isCallMoveToCitiesList, "move to cities list wasn't called")
    XCTAssertTrue(router.isCallDismissSearchView, "dismiss searchView wasn't called")
  }
  
  func testDismiss() throws {
    presenter.didTapCancelButton(from: UIViewController())
    XCTAssertTrue(router.isCallDismissSearchView, "dismiss searchView wasn't called")
  }
}
