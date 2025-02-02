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
  var citiesCoordinatesModel: MockCitiesCoordinatesModel!
  var presenter: CitiesListPresenterProtocol!
  
  override func setUpWithError() throws {
    router = MockRouter(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
    view = MockCitiesListView()
    webManager = MockWebManager()
    storage = MockStorage()
    backgroundManager = MockBackgroundManager()
    citiesCoordinatesModel = MockCitiesCoordinatesModel()
    presenter = CitiesListPresenter(
      router: router,
      view: view,
      webManager: webManager,
      storage: storage,
      citiesCoordinatesModel: citiesCoordinatesModel,
      backgroundManager: backgroundManager
    )
  }
  
  override func tearDownWithError() throws {
    router = nil
    view = nil
    webManager = nil
    storage = nil
    backgroundManager = nil
    citiesCoordinatesModel = nil
    presenter = nil
  }
  
  func testToogle() {
    presenter.toogleUnits()
    XCTAssertTrue(webManager.isUnitsToogled)
  }
  
  func testNumberOfCities() {
    XCTAssertEqual(citiesCoordinatesModel.getAllCitiesCoordinates().count, presenter.showNumberOfCitites())
  }
  
  func testEditingMode() {
    presenter.showEditing()
    XCTAssertTrue(view.editingModeOn)
  }
  
  func testMoveToSearchView() {
    presenter.moveToSearchView(from: UIViewController())
    XCTAssertTrue(router.didCallPresentSearchView)
  }
  
  func testMoveToCityForecast() {
    presenter.goToCityPageView(pageToShow: 1)
    XCTAssertTrue(router.didCallMoveToCityForecast)
  }
  
  func testDeleteCity() {
    presenter.deleteCity(index: 0)
    XCTAssertTrue(citiesCoordinatesModel.isDeleteCalled)
  }
  
  func testFetchingCalled() {
    presenter.fetchDataFor(index: 0, backgroundFrame: CGRect()) { _ in
      
    }
    XCTAssertTrue(webManager.isFetchingShortCityForecastCalled)
  }
}
