//
//  UserInfoController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/29/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

class UserInfoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    var userInfoView: UserInfoViewCollection!
    var defaults = UserDefaults.standard
    var ref = Database.database().reference().child("users")
    var profileurl: String?
    var myPhoneNumber = String()
    
    var countryArrays = [String]()
    var countryPickerView: UIPickerView!
    
    var appUser: AppUser?
    {
        didSet
        {

        }
    }
    
    func fetchUserInfo()
    {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print("userId: ",userId)
        ref.child("users").child(userId).observeSingleEvent(of: .value){ (snapshot) in
            guard let data = snapshot.value as? NSDictionary else { return }
            print("Data from user info: ", data)
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchUserInfo()
        
        view.backgroundColor = UIColor.brown
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews()
    {
        let signUpView = UserInfoViewCollection(frame: self.view.frame)
        self.userInfoView = signUpView
        self.userInfoView.submitAction = submitPressed
        self.userInfoView.cancelAction = cancelPressed
        self.userInfoView.uploadImageAction = uploadImagePressed
        
        view.addSubview(userInfoView)
        
        self.userInfoView.emailTextField.text = appUser?.email!
        self.userInfoView.nameTextField.text = appUser?.username!
        self.userInfoView.countryTextField.text = appUser?.country!
        self.userInfoView.phoneTextField.text = appUser?.phone!
        
        if let profileImageUrl = appUser?.profileurl{
            self.userInfoView.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        self.userInfoView.phoneTextField.delegate = self
        self.userInfoView.phoneTextField.keyboardType = .phonePad
        
        /////////////////////////////////////////////////////////////////////////
        // Country Picker
        for code in NSLocale.isoCountryCodes as [String]
        {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_EN").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            
            countryArrays.append(name)
            countryArrays.sort(by: {(name1, name2) -> Bool in
                name1 < name2
            })
        }
        
        countryPickerView = UIPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.backgroundColor = UIColor.black
        self.userInfoView.countryTextField.inputView = countryPickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SignUpController.dismissCountryPicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.backgroundColor = UIColor.black
        
        self.userInfoView.countryTextField.inputAccessoryView = toolBar

        signUpView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    
    @objc func dismissCountryPicker()
    {
        print("dismissCountryPicker")
        self.view.endEditing(true)
    }
    
    
    func uploadImagePressed()
    {
        print("upload Image Pressed!")
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        // show Image Picker!!!! (Modally)
        present(picker, animated: true, completion: nil)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArrays[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.userInfoView.countryTextField.text = countryArrays[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArrays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = NSAttributedString(string: countryArrays[row], attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return title
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.userInfoView.profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func submitPressed()
    {
        guard let name = userInfoView.nameTextField.text else { return }
        
        // upload profile image
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        // Compress Image into JPEG type
        if let profileImage = self.userInfoView.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
        {
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else
                {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.profileurl = metadata.downloadURL()?.absoluteString
                let uid = Auth.auth().currentUser!.uid
                
                let usersReference = self.ref.child("users").child(uid)
                let values = ["username": name]
                
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if err != nil {
                        print(err ?? "")
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == self.userInfoView.phoneTextField) && textField.text == ""
        {
            textField.text = "+1 (" //your country code default
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.userInfoView.phoneTextField
        {
            let res = phoneMask(phoneTextField: self.userInfoView.phoneTextField, textField: textField, range, string)
            myPhoneNumber = res.phoneNumber != " " ? "+\(res.phoneNumber) " : " "
            if (res.phoneNumber.count == 11) || (res.phoneNumber.count == 0) {
                //phone number entered or completely cleared
            }
            return res.result
        }
        return true
    }
    
    func cancelPressed()
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

