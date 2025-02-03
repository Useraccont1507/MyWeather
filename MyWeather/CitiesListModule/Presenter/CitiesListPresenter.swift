//
//  CitiesListPresenter.swift
//  MyWeather
//
//  Created by Illia Verezei on 01.02.2025.
//

import UIKit

protocol CitiesListViewProtocol: AnyObject {
  func setPresenter(presenter: CitiesListPresenter)
  func reloadingTableView()
  func reloadingTableViewWithAnimation()
  func showingEditingMode()
  func deleteRowAt(index: Int)
  func handleNetworkChange(isConnected: Bool)
}

protocol CitiesListPresenterProtocol {
  func subscribeOnNotification()
  func startNetworkMonitor()
  func toogleUnits()
  func moveToSearchView(from: UIViewController)
  func showEditing()
  func reloadTableViewWithAnimation()
  func showNumberOfCitites() -> Int
  func fetchDataFor(index: Int, backgroundFrame: CGRect, completion: @escaping (ShortCityForecast) -> Void)
  func goToCityControl(pageToShow: Int)
  func deleteCity(index: Int)
}

class CitiesListPresenter: CitiesListPresenterProtocol {
  private let router: RouterProtocol
  private weak var view: CitiesListViewProtocol?
  private var webManager: WebManagerProtocol
  private var storage: StorageProtocol
  private var backgroundManager: BackgroundManagerProtocol
  private var citiesFromStorage: [SharedCityCoordinates]!
  
  init(router: RouterProtocol, view: CitiesListViewProtocol, webManager: WebManagerProtocol, storage: StorageProtocol, backgroundManager: BackgroundManagerProtocol) {
    self.router = router
    self.view = view
    self.webManager = webManager
    self.storage = storage
    self.backgroundManager = backgroundManager
    self.citiesFromStorage = storage.loadCityCoordinates()
    startNetworkMonitor()
  }
  
  func subscribeOnNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTableview), name: NSNotification.Name("SearchViewDismissed"), object: nil)
  }
  
  @objc private func reloadTableview() {
    view?.reloadingTableView()
  }
  
  func startNetworkMonitor() {
    NetworkMonitor.shared.onStatusChange = { [weak self] isConnected in
      self?.view?.handleNetworkChange(isConnected: isConnected)
    }
  }
  
  func toogleUnits() {
    switch webManager.getUnits() {
    case .imperial: webManager.switchToCelsiusUnits()
    case .metric: webManager.switchToFahrenheitUnits()
    }
    reloadTableViewWithAnimation()
  }
  
  func moveToSearchView(from: UIViewController) {
    router.presentSearchView(from: from)
  }
  
  func showEditing() {
    view?.showingEditingMode()
  }
  
  func reloadTableViewWithAnimation() {
    view?.reloadingTableViewWithAnimation()
  }
  
  func showNumberOfCitites() -> Int {
    return citiesFromStorage.count
  }
  
  func fetchDataFor(index: Int, backgroundFrame: CGRect, completion: @escaping (ShortCityForecast) -> Void) {
    let coordinates = citiesFromStorage[index]
    var resultToReturn: ShortCityForecast = ShortCityForecast(
      cityName: nil,
      tempLabelText: nil,
      weatherDescriptionLabel: nil,
      background: nil,
      isSuccess: false
    )
    webManager.fetchTempNow(for: coordinates) { result in
      switch result {
      case .success(let success):
        let layer = self.backgroundManager.getBackground(for: success.weather.first?.id, sunrise: success.sys.sunrise, sunset: success.sys.sunset , frame: backgroundFrame)
        
        resultToReturn = ShortCityForecast(
          cityName: coordinates.name,
          tempLabelText: String(Int(success.main.temp.rounded())) + "°",
          weatherDescriptionLabel: success.weather.first!.description.capitalizeFirstWord(),
          background: layer,
          isSuccess: true
        )
        completion(resultToReturn)
      case .failure(let failure):
        print(failure)
        completion(resultToReturn)
      }
    }
  }
  
  func goToCityControl(pageToShow: Int) {
    router.moveToCityPageControl(pageToShow: pageToShow)
  }
  
  func deleteCity(index: Int) {
    citiesFromStorage.remove(at: index)
    view?.deleteRowAt(index: index)
    storage.saveCityCoordinates(citiesFromStorage)
  }
}
