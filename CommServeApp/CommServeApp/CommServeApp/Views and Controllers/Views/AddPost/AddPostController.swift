//
//  AddPostController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/1/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

class AddPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate //, dropDownProtocol
{
    var imageUrl: String?

    let defaults = UserDefaults.standard
    var ref: DatabaseReference!
    var addPostView : AddPostViewCollection!

    let backgroundImageView = UIImageView()
    let userId = Auth.auth().currentUser?.uid
    let userName = Auth.auth().currentUser?.displayName
    
    var location = ""
    
    var appUser: AppUser?
    {
        didSet
        {
            setupNavBarItems()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        fetchUserInfo()
        setupNavBarItems()
        
        navigationItem.title = "Add a Post"
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.addPostView.locationTextField.text = location
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func setupNavBarItems()
    {
        let titleView = UIButton()
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
        
        navigationItem.titleView = titleView

        
        let logoutBtn = UIButton()
        logoutBtn.setImage(UIImage(named: "Logout.png"), for: .normal)
        logoutBtn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoutBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let item2 = UIBarButtonItem()
        item2.customView = logoutBtn
        navigationItem.rightBarButtonItem = item2
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.title = "Add a Post"
    }
    
    @objc func handleUserInfo()
    {
        let editUserInfoController = UINavigationController(rootViewController: UserInfoController())
        present(editUserInfoController, animated: true, completion: nil)
    }
    
    @objc func blank_Action()
    {
    
    
    }
    
    func setupViews()
    {
        let addPostView = AddPostViewCollection(frame: self.view.frame)
        self.addPostView = addPostView
        self.addPostView.submitAction = submitPressed
        self.addPostView.selectLocationAction = selectLocationPressed
        self.addPostView.uploadImageAction = buttonOnClick
        
        self.addPostView.locationTextField.text = location
        
        view.addSubview(addPostView)
        
        addPostView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func buttonOnClick()
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.uploadImagePressed()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        print("upload Image through Camera Pressed!")
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            
            // show Image Picker!!!! (Modally)
            present(picker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadImagePressed()
    {
        print("upload Image through Photos App Pressed!")
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        // show Image Picker!!!! (Modally)
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker
        {
            self.addPostView.addedImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout()
    {
        print("Logged Out!")
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
            guard let phone = data["phone"] as? String else { return }
            guard let karmaPoints = data["karmaPoints"] as? Int else { return }

            self.appUser = AppUser(username: username, uid: userId, email: email, profileurl: profileurl, country: country, phone: phone, karmaPoints: karmaPoints)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    
    @objc func submitPressed()
    {
        print("Submit Button Pressed!")
        
        if addPostView.button.selectedCategory == ""
        {
            let alertController = UIAlertController(title: "Category Cannnot be Nil", message: "Please select a Category!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let postId = UUID().uuidString
            
            guard let title = addPostView.titlePostTextField.text else { return }
            guard let desc = addPostView.postDescTextField.text else { return }
            let postCategory = addPostView.button.selectedCategory
            guard let location = addPostView.locationTextField.text else { return }
            
            ref.child("users").child(userId!).observeSingleEvent(of: .value)
            { (snapshot) in
                
                // upload profile image
                let imageName = UUID().uuidString
                let storageRef = Storage.storage().reference().child("post_images").child("\(imageName).jpg")

                
                // Compress Image into JPEG type
                if let profileImage = self.addPostView.addedImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
                {
                    _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else
                        {
                            // Uh-oh, an error occurred!
                            print("Error when uploading profile image")
                            print("Error Details: ", error)
                            return
                        }
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        self.imageUrl = metadata.downloadURL()?.absoluteString
                
                        guard let data = snapshot.value as? NSDictionary else { return }
                        guard let usrnm = data["username"] as? String else { return }

                        let reviewData: [String: Any] = [
                            "postId" : postId,
                            "postTitle" : title,
                            "postDesc" : desc,
                            "postCategory" : postCategory,
                            "postLocation" : location,
                            "imageUrl" : self.imageUrl,
                            "userName" : usrnm,
                            "userId" : self.userId,
                        ]
                        
                        let dbRef = Database.database().reference(fromURL: "https://commserveapp.firebaseio.com/")
                        let reviewReference = dbRef.child("posts").child(postCategory).child(postId)
                        reviewReference.updateChildValues(reviewData, withCompletionBlock: { (err, ref) in
                    
                            if err != nil
                            {
                                print(err ?? "")
                                return
                            }
                            
                            self.tabBarController!.selectedIndex = 2
                            self.resetValues()
                        })
                    }
                }
            }
        }
    }
    
    func resetValues()
    {
        addPostView.titlePostTextField.text = ""
        addPostView.postDescTextField.text = ""
        addPostView.locationTextField.text = ""
        location = ""
        addPostView.addedImageView.image = UIImage(named: "default-image")
        addPostView.button.setTitle("Category", for: .normal)
    }
    
    func selectLocationPressed()
    {
        let locationController = LocationController()
        self.navigationController?.pushViewController(locationController, animated: true)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


