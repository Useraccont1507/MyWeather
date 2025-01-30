//
//  Router.swift
//  MyWeather
//
//  Created by Illia Verezei on 29.01.2025.
//

import UIKit

protocol MainRouter {
  var navigationController: UINavigationController { get set }
  var assemblyBuilder: AssemblyBuilder { get set }
}

protocol RouterProtocol: MainRouter {
  func setInitialView(isFirstEnter: Bool)
  func presentSearchView(from: UIViewController)
  func dismissSearchView(from: UIViewController)
  func moveToCitiesListView()
}

class Router: RouterProtocol {
  
  var navigationController: UINavigationController
  var assemblyBuilder: AssemblyBuilder
  
  init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilder) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
  
  func setInitialView(isFirstEnter: Bool) {
    let view = assemblyBuilder.buildFirstGreetengModule(router: self)
    //TODO: - isFirstEnter
//    switch isFirstEnter {
//    case true: view = assemblyBuilder.buildFirstGreetengModule()
//    case false:
//      
//    }
    navigationController.viewControllers = [view]
  }
  
  func presentSearchView(from: UIViewController) {
    let view = assemblyBuilder.buildSearchView(router: self)
    from.present(view, animated: true)
  }
  
  func dismissSearchView(from: UIViewController) {
    from.dismiss(animated: true)
  }
  
  func moveToCitiesListView() {
    //TODO: realization
    navigationController.pushViewController(CitiesListViewController(), animated: true)
  }
}
