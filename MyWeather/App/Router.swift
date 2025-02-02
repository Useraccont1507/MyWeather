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
  func moveToInitialView()
  func presentSearchView(from: UIViewController)
  func dismissSearchView(from: UIViewController)
  func moveToCitiesListView()
  func moveToCityForecast(pageToShow: Int)
}

class Router: RouterProtocol {
  
  var navigationController: UINavigationController
  var assemblyBuilder: AssemblyBuilder
  
  init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilder) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
  
  func moveToInitialView() {
    let view = assemblyBuilder.buildInitialView(router: self)
    navigationController.viewControllers = [view]
  }
  
  func presentSearchView(from: UIViewController) {
    let view = assemblyBuilder.buildSearchModule(router: self)
    from.present(view, animated: true)
  }
  
  func dismissSearchView(from: UIViewController) {
    from.dismiss(animated: true)
  }
  
  func moveToCitiesListView() {
    let view = assemblyBuilder.buildCitiesListModule(router: self)
    navigationController.pushViewController(view, animated: true)
  }
  
  func moveToCityForecast(pageToShow: Int) {
    //TODO: - cityForecast module
    //let vc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    //vc.transferCities(self.cities, pageIndex: indexPath.row)
    //navigationController?.pushViewController(vc, animated: true)
  }
}
