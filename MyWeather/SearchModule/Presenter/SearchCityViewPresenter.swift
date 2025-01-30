//
//  Presenter.swift
//  MyWeather
//
//  Created by Illia Verezei on 30.01.2025.
//

import UIKit

protocol SearchCityViewProtocol: AnyObject {
  func prepareSearchBarPlaceholder(text: String)
  func prepareAlert(title: String, message: String, cancelTitle: String, actionHandler: @escaping (UIAlertAction)->())
  func reloadTableView()
}

protocol SearchCityViewPresenterProtocol {
  func searchTextDidChange(text: String)
  func getNumberOfItems() -> Int
  func getResult(for i: Int) -> CityViewModel
  func didTapOnCity(index: Int, from: UIViewController)
  func didTapCancelButton(from: UIViewController)
}

class SearchCityViewPresenter: SearchCityViewPresenterProtocol {
  
  private let router: RouterProtocol
  private weak var view: SearchCityViewProtocol?
  private var webManager: WebManagerProtocol?
  private var storage: StorageProtocol?
  private var cityData: [CityElement] = []
  private var citiesCoordinatesModel: CitiesCoordinatesModelProtocol?
  
  required init(view: SearchCityViewProtocol, router: RouterProtocol, webManager: WebManagerProtocol, storage: StorageProtocol, citiesCoordinatesModel: CitiesCoordinatesModelProtocol) {
    self.view = view
    self.router = router
    self.webManager = webManager
    self.storage = storage
    self.citiesCoordinatesModel = citiesCoordinatesModel
    view.prepareSearchBarPlaceholder(text: "searchbar_placeholder".localized)
  }
  
  func searchTextDidChange(text: String) {
    webManager?.fetchCityCoordinates(for: text) { result in
      DispatchQueue.main.async { [weak self] in
        switch result {
        case .success(let success):
          self?.cityData = success
          self?.view?.reloadTableView()
        case .failure(let failure):
          print(failure)
        }
      }
    }
  }
  
  func getNumberOfItems() -> Int {
    cityData.count
  }
  
  func getResult(for i: Int) -> CityViewModel {
    CityViewModel(name: cityData[i].name, displayName: cityData[i].displayName)
  }
  
  func didTapOnCity(index: Int, from: UIViewController) {
    guard let storage = storage,
          let citiesCoordinatesModel = citiesCoordinatesModel else { return }
    view?.prepareAlert(title: "search_alert_title".localized,
                       message: "search_alert_message".localized,
                       cancelTitle: "cancel".localized) { _ in
      citiesCoordinatesModel.addCityCoordinatesToArray(self.cityData[index]) {
        storage.saveCityCoordinates(citiesCoordinatesModel.getAllCitiesCoordinates())
      }
      self.router.moveToCitiesListView()
      self.router.dismissSearchView(from: from)
    }

  }
  
  func didTapCancelButton(from: UIViewController) {
    router.dismissSearchView(from: from)
  }
}
