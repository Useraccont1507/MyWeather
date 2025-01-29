//
//  Presenter.swift
//  MyWeather
//
//  Created by Illia Verezei on 29.01.2025.
//

import UIKit

protocol FirstViewProtocol: AnyObject {
  func showGreeting(mainText: String, secondaryText: String, image: UIImage, buttonText: String)
}

protocol FirstViewPresenterProtocol {
  init(view: FirstViewProtocol, router: RouterProtocol)
  func prepareGreeting()
  func didTapButton(from: UIViewController)
}

class FirstViewPresenter: FirstViewPresenterProtocol {
  private var router: RouterProtocol
  weak var view: FirstViewProtocol?
  
  required init(view: FirstViewProtocol, router: RouterProtocol) {
    self.view = view
    self.router = router
  }
  
  func prepareGreeting() {
    view?.showGreeting(
      mainText: "main_greeting".localized,
      secondaryText: "secondary_greeting".localized,
      image: UIImage(named: "CityImage") ?? UIImage(systemName: "exclamationmark.icloud")!,
      buttonText: "select_button_text".localized
    )
  }
  
  func didTapButton(from vc: UIViewController) {
    router.moveToSearchView(from: vc)
  }
}
