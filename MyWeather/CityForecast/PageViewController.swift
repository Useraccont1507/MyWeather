//
//  PageViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class PageViewController: UIPageViewController {
  
  private var pages: [CityViewController] = []
  private var currentPageIndex: Int = 0
  
  lazy private var toolBar = UIToolbar()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //setupToolBar(toolBar)
    self.dataSource = self
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func setupToolBar(_ bar: UIToolbar) {
    bar.setItems([UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(moveToList))], animated: true)
    bar.barTintColor = .clear
    bar.backgroundColor = .clear
    bar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bar)
    
    NSLayoutConstraint.activate([
      bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
    view.sendSubviewToBack(bar)
  }
  
  @objc private func moveToList() {
    
  }
  
  func transferCities(_ cities: [CityCoordinates], pageIndex: Int) {
    cities.forEach { city in
      let vc = CityViewController()
      vc.configure(city)
      pages.append(vc)
    }
    
    setInitialPage(index: pageIndex)
  }
  
  private func setInitialPage(index: Int) {
     guard index >= 0, index < pages.count else { return }
     currentPageIndex = index
     let initialPage = pages[index]
     setViewControllers([initialPage], direction: .forward, animated: false, completion: nil)
   }
}

extension PageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let contentViewController = viewController as? CityViewController,
          let currentIndex = pages.firstIndex(of: contentViewController),
          currentIndex > 0 else { return nil }
    return pages[currentIndex - 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let contentViewController = viewController as? CityViewController,
          let currentIndex = pages.firstIndex(of: contentViewController),
          currentIndex < pages.count - 1 else { return nil }
    return pages[currentIndex + 1]
  }
}
