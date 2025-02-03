//
//  Presenter.swift
//  MyWeather
//
//  Created by Illia Verezei on 30.01.2025.
//

import UIKit

protocol SearchCityViewProtocol: AnyObject {
  func setPresenter(presenter: SearchCityViewPresenterProtocol)
  func prepareAlert(title: String, message: String, cancelTitle: String, actionHandler: @escaping (UIAlertAction)->())
  func reloadTableView()
}

protocol SearchCityViewPresenterProtocol {
  func searchTextDidChange(text: String?)
  func getNumberOfItems() -> Int
  func getResult(for i: Int) -> CityViewModel?
  func didTapOnCity(index: Int, from: UIViewController)
  func didTapCancelButton(from: UIViewController)
}

class SearchCityViewPresenter: SearchCityViewPresenterProtocol {
  
  private let router: RouterProtocol
  private weak var view: SearchCityViewProtocol?
  private var webManager: WebManagerProtocol?
  private var storage: StorageProtocol
  private var cityData: [CityElement] = []
  
  init(view: SearchCityViewProtocol, router: RouterProtocol, webManager: WebManagerProtocol, storage: StorageProtocol) {
    self.view = view
    self.router = router
    self.webManager = webManager
    self.storage = storage
  }
  
  func searchTextDidChange(text: String?) {
    guard let text = text else { return }
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
  
  func getResult(for i: Int) -> CityViewModel? {
    switch cityData.isEmpty {
    case true: return nil
    case false: return CityViewModel(name: cityData[i].name, displayName: cityData[i].displayName)
    }
  }
  
  func didTapOnCity(index: Int, from: UIViewController) {
    view?.prepareAlert(
      title: "search_alert_title".localized,
      message: "search_alert_message".localized,
      cancelTitle: "cancel".localized
    ) {_ in
      self.addCity(index: index)
      NotificationCenter.default.post(name: NSNotification.Name("SearchViewDismissed"), object: nil)
      self.router.dismissSearchView(from: from)
    }
  }
  
  private func addCity(index: Int) {
    let arrayToSave = [SharedCityCoordinates(name: cityData[index].name, lat: cityData[index].lat, lon: cityData[index].lon)]
    self.storage.saveCityCoordinates(arrayToSave)
    self.router.moveToCitiesListView()
  }
  
  func didTapCancelButton(from: UIViewController) {
    router.dismissSearchView(from: from)
  }
}
