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
  func moveToCityPageControl(pageToShow: Int)
  func showCityPage(city: SharedCityCoordinates) -> UIViewController
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
    navigationController.popToRootViewController(animated: true)
    navigationController.setNavigationBarHidden(false, animated: false)
  }
  
  func moveToCityPageControl(pageToShow: Int) {
    let view = assemblyBuilder.buildCityPageControlModule(router: self, pageToShow: pageToShow)
    navigationController.setNavigationBarHidden(true, animated: false)
    navigationController.pushViewController(view, animated: true)
  }
  
  func showCityPage(city: SharedCityCoordinates) -> UIViewController {
    let view = assemblyBuilder.buildCityPage(city: city)
    return view
  }
}
