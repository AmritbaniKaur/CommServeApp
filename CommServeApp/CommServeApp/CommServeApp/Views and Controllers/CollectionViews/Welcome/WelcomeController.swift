//
//  WelcomeController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/28/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class WelcomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    var welcomeView : WelcomeViewCollection!

    // DATA
    let pages =
    [
        WelcomePage(imageName: "Community-Logo", header: "Welcome to CommServe!", body: "Let's get started"),
        WelcomePage(imageName: "Help2", header: "Let's make a difference", body: "By helping the Community"),
        WelcomePage(imageName: "Help3", header: "It's always better", body: "To ask for help"),
        WelcomePage(imageName: "help3-copy", header: "or", body: "Serve others at a right time"),
        WelcomePage(imageName: "logo2", header: "May the force be with you..", body: "And you be the force too!")
    ]
    
    private let previousButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(red:0.19, green:0.32, blue:0.57, alpha:1.0), for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        // matching button action with page control, move(scroll) page
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(red:0.19, green:0.32, blue:0.57, alpha:1.0), for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        // matching button action with page control, move(scroll) page
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let ctr = UIPageControl()
        ctr.currentPage = 0
        ctr.numberOfPages = pages.count
        ctr.currentPageIndicatorTintColor = UIColor(red:0.19, green:0.32, blue:0.57, alpha:1.0)
        ctr.pageIndicatorTintColor = UIColor(red:0.99, green:0.59, blue:0.22, alpha:1.0)
        return ctr
    }()
    
    
    fileprivate func pagingControls()
    {
        let bottomStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.distribution = .fillEqually
        
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    // change the value of the targetContentOffset parameter to adjust where the scrollview finishes its scrolling animation.
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        
        let x = targetContentOffset.pointee.x
        
        // match your current page of page controller with swiping action
        pageControl.currentPage = Int(x / view.frame.width)
        
    }
    
    // called  before changing the size of a presented view controller’s view, (i.e., orientation change: horizontal <-----> vertical
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                // put same page in center
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { (_) in
            
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pagingControls()
        
        navigationController?.isNavigationBarHidden = true
        collectionView?.backgroundColor = .white
        collectionView?.register(WelcomeViewCollection.self, forCellWithReuseIdentifier: "welcomeCellId")
        collectionView?.isPagingEnabled = true  // paging enable
    }
    
    //
    // CollectionView Delegate
    //
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count // number of items per section
    }
    
    // CollectionView CELL populated (reused)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "welcomeCellId", for: indexPath) as! WelcomeViewCollection
        
        if indexPath.item == 4
        {
            let page = pages[indexPath.item]
            cell.page = page
            
            cell.getStartedButton.isHidden = false
            cell.getStartedButton.addTarget(self, action: #selector(jumpToLogin), for: .touchUpInside)
            
            // Background of the cell
            let backImageView = UIImageView()
            backImageView.image = UIImage(named: "Background2")
            backImageView.contentMode = .scaleToFill
            cell.backgroundView = backImageView
        }
        else if indexPath.item == 1
        {
            let page = pages[indexPath.item]
            cell.page = page
            cell.getStartedButton.isHidden = true

            // Background of the cell
            let backImageView = UIImageView()
            backImageView.image = UIImage(named: "Background4")
            backImageView.contentMode = .scaleToFill
            cell.backgroundView = backImageView
        }
        else if indexPath.item == 2
        {
            let page = pages[indexPath.item]
            cell.page = page
            cell.getStartedButton.isHidden = true

            // Background of the cell
            let backImageView = UIImageView()
            backImageView.image = UIImage(named: "Background3")
            backImageView.contentMode = .scaleToFill
            cell.backgroundView = backImageView
        }
        else if indexPath.item == 3
        {
            let page = pages[indexPath.item]
            cell.page = page
            cell.getStartedButton.isHidden = true

            // Background of the cell
            let backImageView = UIImageView()
            backImageView.image = UIImage(named: "Background5")
            backImageView.contentMode = .scaleToFill
            cell.backgroundView = backImageView
        }
        else
        {
            let page = pages[indexPath.item]
            cell.page = page
            cell.getStartedButton.isHidden = true

            // Background of the cell
            let backImageView = UIImageView()
            backImageView.image = UIImage(named: "Background2")
            backImageView.contentMode = .scaleToFill
            cell.backgroundView = backImageView
        }
        return cell

    }
    
    // size of cell (this case, entire screen)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    @objc func jumpToLogin()
    {
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
}
