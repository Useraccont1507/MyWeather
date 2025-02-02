//
//  CitiesCoordinatesModelTest.swift
//  MyWeatherTests
//
//  Created by Illia Verezei on 02.02.2025.
//

import XCTest
@testable import MyWeather

class CitiesCoordinatesModelTest: XCTestCase {
  var model: CitiesCoordinatesModelProtocol!
  
  override func setUpWithError() throws {
    model = CitiesCoordinatesModel()
  }
  
  override func tearDownWithError() throws {
    model = nil
  }  
  
  func testLoad() {
    model.loadCitiesCoordinatesFromStorage(coordinates: [SharedCityCoordinates(name: "baz", lat: "bar", lon: "for")])
    XCTAssertEqual(model.getAllCitiesCoordinates(), [SharedCityCoordinates(name: "baz", lat: "bar", lon: "for")])
  }
  
  func testAdding() {
    model.addCityCoordinatesToArray(CityElement(placeID: 1, licence: "baz", osmType: "bar", osmID: 1, lat: "baz", lon: "baz", cityElementClass: "baz", type: "baz", placeRank: 1, importance: 1, addresstype: "baz", name: "baz", displayName: "baz", address: Address(city: "baz", iso31662Lvl4: "baz", country: "baz", countryCode: "baz"), boundingbox: ["baz"])) { }
    
    XCTAssertEqual(model.getAllCitiesCoordinates()[0].name, "baz")
    XCTAssertEqual(model.getAllCitiesCoordinates()[0].lat, "baz")
    XCTAssertEqual(model.getAllCitiesCoordinates()[0].lon, "baz")
  }
  
  func testDelete() {
    model.addCityCoordinatesToArray(CityElement(placeID: 1, licence: "baz", osmType: "bar", osmID: 1, lat: "baz", lon: "baz", cityElementClass: "baz", type: "baz", placeRank: 1, importance: 1, addresstype: "baz", name: "baz", displayName: "baz", address: Address(city: "baz", iso31662Lvl4: "baz", country: "baz", countryCode: "baz"), boundingbox: ["baz"])) { }
    model.deleteCityCoordinates(0)
    XCTAssertTrue(model.getAllCitiesCoordinates().isEmpty)
  }
}
