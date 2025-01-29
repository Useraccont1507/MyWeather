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
  func buildFirstGreetengModule(router: RouterProtocol) -> UIViewController {
    let view = FirstViewController()
    let presenter = FirstViewPresenter(view: view, router: router)
    view.setPresenter(presenter)
    return view
  }
  
  func buildSearchView() -> UIViewController {
    //TODO: - Search
    return UIViewController()
  }
}
