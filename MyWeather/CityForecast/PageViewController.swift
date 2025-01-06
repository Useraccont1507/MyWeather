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
  private let pageControl = UIPageControl()
  
  lazy private var moveToListButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMoveToListButton(moveToListButton)
    setupPageControl(pageControl)
    self.dataSource = self
    self.delegate = self
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func setupMoveToListButton(_ button: UIButton) {
    button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
    button.contentVerticalAlignment = .fill
    button.contentHorizontalAlignment = .fill
    button.tintColor = .white
    button.addTarget(self, action: #selector(moveToList), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 28),
      button.heightAnchor.constraint(equalToConstant: 16),
      button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
    ])
  }
  
  func setupPageControl(_ control: UIPageControl) {
    control.backgroundColor = .gray.withAlphaComponent(0.3)
    control.layer.cornerRadius = 12
    control.numberOfPages = pages.count
    control.currentPage = currentPageIndex
    control.pageIndicatorTintColor = .lightGray
    control.currentPageIndicatorTintColor = .white
    control.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    control.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(control)
    
    NSLayoutConstraint.activate([
      pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc private func moveToList() {
    navigationController?.popViewController(animated: true)
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
  }
  
  @objc private func pageControlValueChanged() {
      let newPageIndex = pageControl.currentPage
      let direction: UIPageViewController.NavigationDirection = newPageIndex > currentPageIndex ? .forward : .reverse
      currentPageIndex = newPageIndex
      setViewControllers([pages[newPageIndex]], direction: direction, animated: true, completion: nil)
    }
    
  
  func transferCities(_ cities: [CityCoordinates], pageIndex: Int) {
    cities.forEach { city in
      let vc = CityViewController()
      vc.configure(city)
      pages.append(vc)
    }
    pageControl.numberOfPages = pages.count
    setInitialPage(index: pageIndex)
  }
  
  private func setInitialPage(index: Int) {
     guard index >= 0, index < pages.count else { return }
     currentPageIndex = index
     let initialPage = pages[index]
     setViewControllers([initialPage], direction: .forward, animated: true, completion: nil)
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

extension PageViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed, let visibleViewController = viewControllers?.first as? CityViewController, let index = pages.firstIndex(of: visibleViewController) {
      currentPageIndex = index
      pageControl.currentPage = currentPageIndex
    }
  }
}
