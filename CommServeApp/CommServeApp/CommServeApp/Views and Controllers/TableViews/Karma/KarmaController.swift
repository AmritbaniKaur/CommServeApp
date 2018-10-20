//
//  KarmaController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/6/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

class KarmaController: UITableViewController
{
    let defaults = UserDefaults.standard
    weak var activityIndicatorView: UIActivityIndicatorView!
    var ref: DatabaseReference!
    var usersRef = Database.database().reference().child("users")
    
    var usersArray = [AppUser]()
    
    var appUser: AppUser?
    {
        didSet
        {
            setupNavBarItems()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        usersRef.observe(.value, with: {(snapshot) in
            self.usersArray.removeAll()
            
            print("Data Snapshot: ", snapshot)
            
            for child in snapshot.children
            {
                let childSnapshot = child as! DataSnapshot
                let fav = AppUser(snapshot: childSnapshot)
                print("Checked from new observe: ", fav)
                self.usersArray.append(fav)
            }
            self.tableView.reloadData()
        })
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.tableView.reloadData()
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // add activityIndicatorView to view controller, so viewWillAppear will be called
        self.activityIndicatorView = activityIndicatorView
        
        navigationItem.title = "Karma Points"
        
        let logoutBtn = UIButton()
        logoutBtn.setImage(UIImage(named: "Logout.png"), for: .normal)
        logoutBtn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoutBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let item1 = UIBarButtonItem()
        item1.customView = logoutBtn
        navigationItem.rightBarButtonItem = item1
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchUserInfo()
        
        tableView.register(KarmaViewCollection.self, forCellReuseIdentifier: "cellidcheck")
        
        // Uncomment the following line to preserve selection between presentations
        tableView.reloadData()
    }
    
    private func setupNavBarItems()
    {
        guard let username = appUser?.username else { return }
        print(username)
        
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
        
        if let profileImageUrl = appUser?.profileurl
        {
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
            guard let email = data["email"] as? String else { return }
            guard let profileurl = data["profileurl"] as? String else { return }
            guard let country = data["country"] as? String else { return }
            guard let phone = data["phone"] as? String else { return }
            guard let karmaPoints = data["karmaPoints"] as? Int else { return }
            
            self.appUser = AppUser(username: username, uid: userId, email: email, profileurl: profileurl, country: country, phone: phone, karmaPoints: karmaPoints)
        }
    }
    
    
    // called before the view controller's view is about to be added to a view hierarchy and before any animations are configured for showing the view.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupNavBarItems()
    }
    
    
    // Table View Cell for Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = KarmaViewCollection(style: .default, reuseIdentifier: "cellidcheck")
        
        let username = usersArray[indexPath.row].username!
        let karmaPoints = usersArray[indexPath.row].karmaPoints!
        
        let points = String(karmaPoints)
        
        cell.titleLabel.text = "User: " + username
        cell.locationLabel.text = "Points: " + points

        // Background of the cell
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "cell-background")
        backImageView.contentMode = .scaleToFill
        cell.backgroundView = backImageView
        
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usersArray.count
    }
    
    // Height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
}

