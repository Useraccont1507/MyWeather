//
//  Presenter.swift
//  MyWeather
//
//  Created by Illia Verezei on 29.01.2025.
//

import UIKit

protocol FirstViewProtocol: AnyObject {
 
}

protocol FirstViewPresenterProtocol {
  func didTapButton(from: UIViewController)
}

class FirstViewPresenter: FirstViewPresenterProtocol {
  private var router: RouterProtocol
  private weak var view: FirstViewProtocol?
  
  required init(view: FirstViewProtocol, router: RouterProtocol) {
    self.view = view
    self.router = router
  }
  
  func didTapButton(from vc: UIViewController) {
    router.presentSearchView(from: vc)
  }
}
