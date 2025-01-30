//
//  AssemblyBuilder.swift
//  MyWeather
//
//  Created by Illia Verezei on 29.01.2025.
//

import UIKit

protocol AssemblyBuilderProtocol {
  func buildFirstGreetengModule(router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder {
  
  private var webManager = WebManager()
  private var storage = Storage()
  private var citiesCoordiantesModel = CitiesCoordinatesModel()
  
  func buildFirstGreetengModule(router: RouterProtocol) -> UIViewController {
    let view = FirstViewController()
    let presenter = FirstViewPresenter(view: view, router: router)
    view.setPresenter(presenter)
    return view
  }
  
  func buildSearchView(router: RouterProtocol) -> UIViewController {
    let view = SearchCityViewController()
    let presenter = SearchCityViewPresenter(view: view,
                                            router: router,
                                            webManager: webManager,
                                            storage: storage,
                                            citiesCoordinatesModel: citiesCoordiantesModel)
    view.setPresenter(presenter: presenter)
    return view
  }
}
