//
//  SwipingPhotosController.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/17/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var cardViewModel: CardViewModel? {
        didSet {
            guard let cardViewModel = cardViewModel else { return }
            
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            
            if let controller = controllers.first {
                setViewControllers([controller], direction: .forward, animated: false)
                setupBarViews()
            }
        }
    }
    
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let isCardViewMode: Bool
    
    var controllers = [UIViewController]()
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        
        if isCardViewMode {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func setupBarViews() {
        cardViewModel?.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
        view.addSubview(barsStackView)
        
        var paddingTop: CGFloat = 8
        
        if !isCardViewMode {
            paddingTop += UIApplication.shared.statusBarFrame.height
        }
        
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        /*let currentController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentController) {
            
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
                
            } else {
                let prevIndex = max(0, index - 1)
                let prevController = controllers[prevIndex]
                setViewControllers([prevController], direction: .forward, animated: false)
                barsStackView.arrangedSubviews[prevIndex].backgroundColor = .white
            }
        }*/
        
        let currentController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentController) {
            let tapLocation = gesture.location(in: view)
            let delta = tapLocation.x > view.frame.width / 2 ? 1 : -1
            let nextIndex = max(0, min(controllers.count - 1, index + delta))
            if index == nextIndex { return }
            let nextController = controllers[nextIndex]
            let direction: NavigationDirection = delta == 1 ? .forward : .reverse
            delegate?.pageViewController?(self, willTransitionTo: [nextController])
            setViewControllers([nextController], direction: direction, animated: false) { (done) in
                if !done { return }
                self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: self.controllers, transitionCompleted: done)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        barsStackView.arrangedSubviews[index].backgroundColor = .white
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        barsStackView.arrangedSubviews[index].backgroundColor = .white
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}
