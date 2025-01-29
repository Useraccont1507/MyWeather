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
  func moveToSearchView(from: UIViewController)
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
  
  func moveToSearchView(from: UIViewController) {
    let vc = SearchCityViewController()
    from.present(vc, animated: true)
  }
}
