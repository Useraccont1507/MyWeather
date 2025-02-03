//
//  CititesListPresenterView.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 02.02.2025.
//

import XCTest
@testable import MyWeather

class MockCitiesListView: CitiesListViewProtocol {
  var editingModeOn = false
  
  func setPresenter(presenter: MyWeather.CitiesListPresenter) { }
  
  func reloadingTableView() {
     
  }
  
  func reloadingTableViewWithAnimation() {
    
  }
  
  func showingEditingMode() {
    editingModeOn = true
  }
  
  func deleteRowAt(index: Int) {
     
  }
  
  func handleNetworkChange(isConnected: Bool) {
     
  }
}

class CitiesListPresenterTests: XCTestCase {
  
  var router: MockRouter!
  var view: MockCitiesListView!
  var webManager: MockWebManager!
  var storage: MockStorage!
  var backgroundManager: MockBackgroundManager!
  var presenter: CitiesListPresenterProtocol!
  
  override func setUpWithError() throws {
    router = MockRouter(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
    view = MockCitiesListView()
    webManager = MockWebManager()
    storage = MockStorage()
    backgroundManager = MockBackgroundManager()
    presenter = CitiesListPresenter(
      router: router,
      view: view,
      webManager: webManager,
      storage: storage,
      backgroundManager: backgroundManager
    )
  }
  
  override func tearDownWithError() throws {
    router = nil
    view = nil
    webManager = nil
    storage = nil
    backgroundManager = nil
    presenter = nil
  }
  
  func testToogle() {
    presenter.toogleUnits()
    XCTAssertTrue(webManager.isUnitsToogled)
  }
  
  func testNumberOfCities() {
    XCTAssertEqual(storage.loadCityCoordinates().count, presenter.showNumberOfCitites())
  }
  
  func testEditingMode() {
    presenter.showEditing()
    XCTAssertTrue(view.editingModeOn)
  }
  
  func testMoveToSearchView() {
    presenter.moveToSearchView(from: UIViewController())
    XCTAssertTrue(router.didCallPresentSearchView)
  }
  
  func testMoveToCityPageControl() {
    presenter.goToCityControl(pageToShow: 1)
    XCTAssertTrue(router.didCallMoveCityPageControl)
  }
  
  func testDeleteCity() {
    presenter.deleteCity(index: 0)
    XCTAssertTrue(storage.isSaveCalled)
  }
  
  func testFetchingCalled() {
    presenter.fetchDataFor(index: 0, backgroundFrame: CGRect()) { _ in
      
    }
    XCTAssertTrue(webManager.isFetchingShortCityForecastCalled)
  }
}
