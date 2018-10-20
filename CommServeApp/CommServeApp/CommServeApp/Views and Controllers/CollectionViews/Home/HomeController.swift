//
//  HomeController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/29/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout  //UITableViewController
{
    let specialCellId = "specialCellId"
    let studyCellId = "studyCellId"
    let travelCellId = "travelCellId"
    let foodCellId = "foodCellId"

    var favRef = Database.database().reference().child("pinned")
    var checkRef = Database.database().reference().child("completed")
    var ref: DatabaseReference!
    weak var activityIndicatorView: UIActivityIndicatorView!
    let defaults = UserDefaults.standard
    
    var userPost: UserPost?
    var postArray = [UserPost]()
    var favArray = [UserPost]()
    var checkArray = [UserPost]()

    var cellView = HomeViewCollection()

    let titles = ["Study", "Travel", "Food", "Special"]

    var appUser: AppUser?
    {
        didSet
        {
            setupNavBarItems()
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        setupNavBarItems()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        self.collectionView?.backgroundView = activityIndicatorView
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Study"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Avenir", size: 20)
        navigationItem.titleView = titleLabel
        
        // add activityIndicatorView to view controller, so viewWillAppear will be called
        self.activityIndicatorView = activityIndicatorView
        navigationController?.isNavigationBarHidden = false
        
        let logoutBtn = UIButton()
        logoutBtn.setImage(UIImage(named: "Logout.png"), for: .normal)
        logoutBtn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoutBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let item1 = UIBarButtonItem()
        item1.customView = logoutBtn
        navigationItem.rightBarButtonItem = item1
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        fetchUserInfo()
        
        setupCollectionView()
        setupMenuBar()
        
        setTitleForIndex(0)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        favRef.child(userId).observe(.value, with: {(snapshot) in
            self.favArray.removeAll()
            
            for child in snapshot.children
            {
                let childSnapshot = child as! DataSnapshot
                let fav = UserPost(snapshot: childSnapshot)
                self.favArray.insert(fav, at: 0)
            }
            self.collectionView?.reloadData()
        })
        
        checkRef.child(userId).observe(.value, with: {(snapshot) in
            self.checkArray.removeAll()
            
            for child in snapshot.children
            {
                let childSnapshot = child as! DataSnapshot
                let fav = UserPost(snapshot: childSnapshot)
                self.checkArray.insert(fav, at: 0)
            }
            self.collectionView?.reloadData()
        })
    }
    
    func setupCollectionView()
    {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(HomeViewCollection.self, forCellWithReuseIdentifier: studyCellId)
        collectionView?.register(SpecialCell.self, forCellWithReuseIdentifier: specialCellId)
        collectionView?.register(FoodCell.self, forCellWithReuseIdentifier: foodCellId)
        collectionView?.register(TravelCell.self, forCellWithReuseIdentifier: travelCellId)
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    private func setupMenuBar()
    {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red: 219/255, green: 48/255, blue: 112/255, alpha: 1.0)
        view.addSubview(bgView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: bgView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: bgView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    // for the white horizontalBar's left anchor when scrolled
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    // Synchronize selection with menuBar's collectionView
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        
        setTitleForIndex(Int(index))
    }
    
    // synchronize collectionView with menuBar's scroll
    func scrollToMenuIndex(_ menuIndex: Int)
    {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
        setTitleForIndex(menuIndex)
    }
    
    func setTitleForIndex(_ index: Int)
    {
        self.navigationController?.navigationBar.tintColor = UIColor.white // for titles, buttons, etc.
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        let titleColor = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        navigationItem.title = "  \(titles[index])"
        let textcolor = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textcolor

    }
    
    func setupNavBarItems()
    {
        guard let username = appUser?.username else { return }
        
        let titleView = UIButton() //UIView()
        titleView.frame = CGRect(x:0, y:0, width:100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = appUser?.profileurl{
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = appUser?.username
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Avenir", size: 16)
        nameLabel.textColor = UIColor.white
        
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        titleView.addTarget(self, action: #selector(handleUserInfo), for: .touchUpInside)
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func handleUserInfo()
    {
        let editUserInfoController = UINavigationController(rootViewController: UserInfoController())
        
        self.navigationController?.navigationBar.tintColor = UIColor.white // for titles, buttons, etc.
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont]
        
        navigationController?.navigationBar.isTranslucent = true
        
        present(editUserInfoController, animated: true, completion: nil)
        
    }
    
    @objc func handleLogout()
    {
        do{
            try Auth.auth().signOut()
            defaults.set(false, forKey: "UserIsLoggedIn")
            let loginController = UINavigationController(rootViewController: LoginController())
            present(loginController, animated: true, completion: nil)
        }
        catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func fetchUserInfo()
    {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(userId).observeSingleEvent(of: .value){ (snapshot) in
            guard let data = snapshot.value as? NSDictionary else { return }
            guard let username = data["username"] as? String else { return }
            guard let uid = data["uid"] as? String else { return }
            guard let email = data["email"] as? String else { return }
            guard let profileurl = data["profileurl"] as? String else { return }
            guard let country = data["country"] as? String else { return }
            guard let karmaPoints = data["karmaPoints"] as? Int else { return }
            guard let phone = data["phone"] as? String else { return }

            self.appUser = AppUser(username: username, uid: userId, email: email, profileurl: profileurl, country: country, phone: phone, karmaPoints: karmaPoints)
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return titles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.item == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: studyCellId, for: indexPath)

            return cell
        }
        else if indexPath.item == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: travelCellId, for: indexPath)

            return cell
        }
        else if indexPath.item == 2
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: foodCellId, for: indexPath)

            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: specialCellId, for: indexPath)
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white // for titles, buttons, etc.
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont]

        navigationController?.navigationBar.isTranslucent = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


