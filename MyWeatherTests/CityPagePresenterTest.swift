//
//  CityPagePresenterTest.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 02.02.2025.
//

import XCTest
@testable import MyWeather

class MockCityPageView: CityViewProtocol {
  func setPresenter(presenter: any MyWeather.CityPagePresenterProtocol) {
     
  }
  
  func handleNetworkChange(isConnected: Bool) {
     
  }
  
  func prepareDataForView(background: CAGradientLayer?, cityName: String, dateString: String, weatherIcon: String, description: String, temp: Double, sunrise: Int?, sunset: Int?, timezone: Int) {
     
  }
  
  func prepareDataForCollectionView(hourlyWeahterList: [MyWeather.List], timezone: TimeZone?) {
     
  }
  
  func reloadCollectionView() {
     
  }
  
  func startLoadingView() {
     
  }
  
  func stopLoadingView() {
     
  }
  
  func prepareDataForOtherViews(visibility: Int, wind: MyWeather.Wind, pressure: Int, humidity: Int) {
     
  }
}

class CityPagePresenterTest: XCTestCase {
  var router: MockRouter!
  var view: MockCityPageView!
  var presenter: CityPagePresenterProtocol!
  var webManager: MockWebManager!
  var citiesCoordinatesModel: MockCitiesCoordinatesModel!
  var backgroundManager: MockBackgroundManager!
  
  
  override func setUpWithError() throws {
    router = MockRouter(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
    view = MockCityPageView()
    webManager = MockWebManager()
    citiesCoordinatesModel = MockCitiesCoordinatesModel()
    backgroundManager = MockBackgroundManager()
    presenter = CityPagePresenter(
      view: view,
      city: citiesCoordinatesModel.getAllCitiesCoordinates().first!,
      webManager: webManager,
      backgroundManager: backgroundManager,
      viewSize: CGRect()
    )
  }
  
  override func tearDownWithError() throws {
    router = nil
    view = nil
    presenter = nil
    citiesCoordinatesModel = nil
    webManager = nil
    backgroundManager = nil
  }
  
  func testGetForecastNow() {
    presenter.fetchForecastNow(viewFrame: CGRect())
    XCTAssertTrue(webManager.isFetchingShortCityForecastCalled)
  }
  
  func testGetHourlyForecast() {
    presenter.fetchForecastHourly {}
    XCTAssertTrue(webManager.isFetchingHourlyForecastCalled)
  }
}
