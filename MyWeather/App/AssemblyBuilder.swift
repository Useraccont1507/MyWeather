//
//  AssemblyBuilder.swift
//  MyWeather
//
//  Created by Illia Verezei on 29.01.2025.
//

import UIKit

protocol AssemblyBuilderProtocol {
  func buildFirstGreetengModule(router: RouterProtocol) -> UIViewController
  func buildSearchModule(router: RouterProtocol) -> UIViewController
  func buildCitiesListModule(router: RouterProtocol) -> UIViewController
  func buildCityPageControlModule(router: RouterProtocol, pageToShow: Int) -> UIViewController
  func buildCityPage(city: SharedCityCoordinates) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
  private var webManager = WebManager()
  private var storage = Storage()
  private var citiesCoordiantesModel = CitiesCoordinatesModel()
  private var backgroundManager = BackgroundManager()
  
  init() {
    citiesCoordiantesModel.loadCitiesCoordinatesFromStorage(coordinates: storage.loadCityCoordinates())
  }
  
  func buildInitialView(router: RouterProtocol) -> UIViewController {
    if storage.isFirstEnter() {
      buildFirstGreetengModule(router: router)
    } else {
      buildCitiesListModule(router: router)
    }
  }
  
  func buildFirstGreetengModule(router: RouterProtocol) -> UIViewController {
    let view = FirstViewController()
    let presenter = FirstViewPresenter(view: view, router: router)
    view.setPresenter(presenter)
    return view
  }
  
  func buildSearchModule(router: RouterProtocol) -> UIViewController {
    let view = SearchCityViewController()
    let presenter = SearchCityViewPresenter(
      view: view,
      router: router,
      webManager: webManager,
      storage: storage,
      citiesCoordinatesModel: citiesCoordiantesModel
    )
    view.setPresenter(presenter: presenter)
    return view
  }
  
  func buildCitiesListModule(router: RouterProtocol) -> UIViewController {
    let view = CitiesListViewController()
    let presenter = CitiesListPresenter(
      router: router,
      view: view,
      webManager: webManager,
      storage: storage,
      citiesCoordinatesModel: citiesCoordiantesModel,
      backgroundManager: backgroundManager
    )
    view.setPresenter(presenter: presenter)
    return view
  }
  
  func buildCityPageControlModule(router: any RouterProtocol, pageToShow: Int) -> UIViewController {
    let view = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let presenter = CityForecastPresenter(
      router: router,
      view: view,
      webManager: webManager,
      citiesCoordinatesModel: citiesCoordiantesModel,
      backgroundManager: backgroundManager,
      pageindex: pageToShow
    )
    view.setPresenter(presenter: presenter)
    return view
  }
  
  func buildCityPage(city: SharedCityCoordinates) -> UIViewController {
    let view = CityViewController()
    let presenter = CityViewPresenter(
      view: view,
      city: city,
      webManager: webManager,
      backgroundManager: backgroundManager,
      viewSize: view.view.bounds
    )
    view.setPresenter(presenter: presenter)
    return view
  }
}
