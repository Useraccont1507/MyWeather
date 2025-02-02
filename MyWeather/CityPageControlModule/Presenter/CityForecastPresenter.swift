//
//  CityForecastPresenter.swift
//  MyWeather
//
//  Created by Illia Verezei on 02.02.2025.
//

import UIKit

protocol CityViewControlProtocol: AnyObject {
  func setPresenter(presenter: CityForecastPresenter)
  func preparePageControl(initialPage: UIViewController?, numberOfPages: Int, currentPage: Int)
  func changeCurrentPage(pages: [UIViewController], direction: UIPageViewController.NavigationDirection)
}

protocol CityPageControlPresenterProtocol {
  func getPages() -> [UIViewController]
  func getPageIndex() -> Int
  func moveToRootView()
  func changePage(newPageIndex: Int)
  func calculateInitialPage(index: Int) -> UIViewController?
  func showViewConrollerBefore(viewControllerBefore: UIViewController) -> UIViewController?
  func showViewConrollerAfter(viewControllerAfter: UIViewController) -> UIViewController?
  func changePageIndex(index: Int)
}

class CityForecastPresenter: CityPageControlPresenterProtocol {
  private let router: RouterProtocol
  private weak var view: CityViewControlProtocol?
  private var webManager: WebManagerProtocol
  private var backgroundManager: BackgroundManagerProtocol
  private var citiesCoordinatesModel: CitiesCoordinatesModelProtocol
  private var pages: [UIViewController] = []
  private var pageIndex: Int
  
  init(router: RouterProtocol, view: CityViewControlProtocol, webManager: WebManagerProtocol, citiesCoordinatesModel: CitiesCoordinatesModelProtocol, backgroundManager: BackgroundManagerProtocol, pageindex: Int) {
    self.router = router
    self.view = view
    self.webManager = webManager
    self.citiesCoordinatesModel = citiesCoordinatesModel
    self.backgroundManager = backgroundManager
    self.pageIndex = pageindex
    configurePages()
    view.preparePageControl(initialPage: calculateInitialPage(index: pageindex), numberOfPages: pages.count, currentPage: pageindex)
  }
  
  private func configurePages() {
    let cities = citiesCoordinatesModel.getAllCitiesCoordinates()
    cities.forEach { city in
      let view = router.showCityPage(city: city)
      pages.append(view)
    }
  }
  
  func getPageIndex() -> Int {
    pageIndex
  }
  
  func changePage(newPageIndex: Int) {
    let direction: UIPageViewController.NavigationDirection = newPageIndex > pageIndex ? .forward : .reverse
    view?.changeCurrentPage(pages: [pages[newPageIndex]], direction: direction)
  }
  
  func calculateInitialPage(index: Int) -> UIViewController? {
    guard index >= 0, index < pages.count else { return nil }
    pageIndex = index
    let initialPage = pages[index]
    return initialPage
  }
  
  func showViewConrollerBefore(viewControllerBefore: UIViewController) -> UIViewController? {
    guard let contentViewController = viewControllerBefore as? CityViewController,
          let currentIndex = pages.firstIndex(of: contentViewController),
          currentIndex > 0 else { return nil }
    return pages[currentIndex - 1]
  }
  
  func showViewConrollerAfter(viewControllerAfter: UIViewController) -> UIViewController? {
    guard let contentViewController = viewControllerAfter as? CityViewController,
          let currentIndex = pages.firstIndex(of: contentViewController),
          currentIndex < pages.count - 1 else { return nil }
    return pages[currentIndex + 1]
  }
  
  func getPages() -> [UIViewController] {
    pages
  }
  
  func changePageIndex(index: Int) {
    self.pageIndex = index
  }
  
  func moveToRootView() {
    router.moveToCitiesListView()
  }
}
