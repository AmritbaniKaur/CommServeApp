//
//  SignUpController.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/28/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    var myPhoneNumber = String()

    var signUpView: SignUpViewCollection!
    var defaults = UserDefaults.standard
    var ref: DatabaseReference!
    var profileurl: String?
    
    var countryArrays = [String]()
    var countryPickerView: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews()
    {
        let signUpView = SignUpViewCollection(frame: self.view.frame)
        self.signUpView = signUpView
        self.signUpView.submitAction = submitPressed
        self.signUpView.cancelAction = cancelPressed
        self.signUpView.uploadImageAction = uploadImagePressed
        
        self.signUpView.phoneTextField.delegate = self
        self.signUpView.phoneTextField.keyboardType = .phonePad
        
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
        self.signUpView.countryTextField.inputView = countryPickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SignUpController.dismissCountryPicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.backgroundColor = UIColor.black
        
        self.signUpView.countryTextField.inputAccessoryView = toolBar
        
        //////////////////////////////////////////////
        // Add Subview and Constraints
        view.addSubview(signUpView)
        signUpView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    @objc func dismissCountryPicker()//gesture: UITapGestureRecognizer)
    {
        print("dismissCountryPicker")
        self.view.endEditing(true)
    }
    
    func uploadImagePressed()
    {
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
        self.signUpView.countryTextField.text = countryArrays[row]
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
            self.signUpView.profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func submitPressed()
    {
        guard let email = signUpView.emailTextField.text else { return }
        guard let password = signUpView.passwordTextField.text else { return }
        guard let name = signUpView.nameTextField.text else { return }
        guard let country = signUpView.countryTextField.text else { return }
        guard let cellphone = signUpView.phoneTextField.text else { return }
        let karmaPoints = 0
        
        // upload profile image
        let imageName = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        // Compress Image into JPEG type
        if let profileImage = self.signUpView.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
        {
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in

                guard let metadata = metadata else
                {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.profileurl = metadata.downloadURL()?.absoluteString
                
                Auth.auth().createUserAndRetrieveData(withEmail: email, password: password) { (result, err) in
                    if let err = err
                    {
                        print(err.localizedDescription)
                    }
                    else
                    {
                        guard let uid = result?.user.uid else { return }
                        
                         let userData: [String: Any] = [
                         "username" : name,
                         "uid" : uid,
                         "email" : email,
                         "password" : password,
                         "profileurl" : self.profileurl,
                         "country" : country,
                         "phone" : cellphone,
                         "karmaPoints" : karmaPoints
                         ]
                        
                        self.ref.child("users/\(uid)").setValue(userData)
                        self.defaults.set(false, forKey: "UserIsLoggedIn")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == self.signUpView.phoneTextField) && textField.text == ""
        {
            textField.text = "+1 ("
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.signUpView.phoneTextField
        {
            let res = phoneMask(phoneTextField: self.signUpView.phoneTextField, textField: textField, range, string)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}
