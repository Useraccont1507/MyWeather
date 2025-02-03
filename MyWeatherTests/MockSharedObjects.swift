//
//  MockRouter.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 31.01.2025.
//

import UIKit
@testable import MyWeather

class MockRouter: RouterProtocol {
  var didCallMoveToCityForecast = false
  var didCallMoveCityPageControl = false
  var didShowCityPage = false
  
  func moveToInitialView() { }
  
  func moveToCityForecast(pageToShow: Int) {
    didCallMoveToCityForecast = true
  }
  
  func moveToCityPageControl(pageToShow: Int) {
    didCallMoveCityPageControl = true
  }
  
  func showCityPage(city: MyWeather.SharedCityCoordinates) -> UIViewController {
    didShowCityPage = true
    return UIViewController()
  }
  
  var navigationController: UINavigationController
  var assemblyBuilder: MyWeather.AssemblyBuilder
  
  var didCallPresentSearchView = false
  var isCallDismissSearchView = false
  var isCallMoveToCitiesList = false
  
  func setInitialView(isFirstEnter: Bool) {}
  
  func presentSearchView(from: UIViewController) {
    didCallPresentSearchView = true
  }
  
  func dismissSearchView(from: UIViewController) {
    isCallDismissSearchView = true
  }
  
  func moveToCitiesListView() {
    isCallMoveToCitiesList = true
  }
  
  init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilder) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
}

class MockWebManager: WebManagerProtocol {
  var isFetchingCityCoordinatesCalled = false
  var isFetchingShortCityForecastCalled = false
  var isFetchingHourlyForecastCalled = false
  var isUnitsToogled = false
  
  let mockCityData = [CityElement(placeID: 0,
                              licence: "baz",
                              osmType: "bar",
                              osmID: 0,
                              lat: "baz",
                              lon: "bar",
                              cityElementClass: "for",
                              type: "baz",
                              placeRank: 0,
                              importance: 0,
                              addresstype: "bar",
                              name: "bar",
                              displayName: "baz",
                              address: Address(city: "baz", iso31662Lvl4: "bar", country: "bar", countryCode: "for"), boundingbox: ["baz"])]
  
  func getUnits() -> MyWeather.Units {
    .metric
  }
  
  func switchToFahrenheitUnits() {
    isUnitsToogled = true
  }
  
  func switchToCelsiusUnits() {
    isUnitsToogled = true
  }
  
  func fetchCityCoordinates(for text: String, completion: @escaping (Result<[MyWeather.CityElement], any Error>) -> ()) {
    isFetchingCityCoordinatesCalled = true
    completion(.success(self.mockCityData))
  }
  
  func fetchTempNow(for coordinates: MyWeather.SharedCityCoordinates, completion: @escaping (Result<MyWeather.WeatherNow, any Error>) -> ()) {
    isFetchingShortCityForecastCalled = true
  }
  
  func fetchTempHourly(for coordinates: MyWeather.SharedCityCoordinates, completion: @escaping (Result<MyWeather.WeatherHourly, any Error>) -> ()) {
    isFetchingHourlyForecastCalled = true
  }
}

class MockStorage: StorageProtocol {
  var isSaveCalled = false
  
  private var cities: [MyWeather.SharedCityCoordinates] = [SharedCityCoordinates(name: "bar", lat: "bar", lon: "bar")]
  
  func isFirstEnter() -> Bool {
    true
  }
  
  func saveCityCoordinates(_ citiesCoordinates: [MyWeather.SharedCityCoordinates]) {
    isSaveCalled = true
    cities = citiesCoordinates
  }
  
  func loadCityCoordinates() -> [MyWeather.SharedCityCoordinates] {
    cities
  }
}

class MockBackgroundManager: BackgroundManagerProtocol {
  func getBackground(for weatherCode: Int?, sunrise: Int?, sunset: Int?, frame: CGRect) -> CAGradientLayer? {
    nil
  }
}
