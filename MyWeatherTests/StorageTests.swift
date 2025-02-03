//
//  StorageTests.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 02.02.2025.
//

import XCTest
@testable import MyWeather

class StorageTests: XCTestCase {
  var storage: StorageProtocol!
  
  override func setUpWithError() throws {
    storage = Storage()
  }
  
  override func tearDownWithError() throws {
    storage = nil
  }
  
  func test() {
    storage.saveCityCoordinates([SharedCityCoordinates(name: "bar", lat: "bar", lon: "bar")])
    XCTAssertEqual("bar", storage.loadCityCoordinates()[0].name)
  }
}
