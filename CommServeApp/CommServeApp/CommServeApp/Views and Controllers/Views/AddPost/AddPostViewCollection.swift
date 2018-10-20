//
//  AddPostViewCollection.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/1/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

class AddPostViewCollection: UIView
{
    var submitAction: (() -> Void)?
    var selectLocationAction: (() -> Void)?
    let containerView = UIView(frame: CGRect(x:0,y:0,width:320,height:500))
    var uploadImageAction: (() -> Void)?

    var button = dropDownBtn()

    let backgroundImageView: UIImageView =
    {
        let img = UIImageView()
        img.image = UIImage(named: "Background3")
        img.contentMode = .scaleToFill
        return img
    }()
    
    let titlePostTextField: UITextField =
    {
        let titleText = UITextField(title: "Title", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.35))
        return titleText
    }()
    
    let postDescTextField: UITextView =
    {
        let contentText = UITextView(frame: CGRect(x:0, y:0, width: 320, height: 350))
        contentText.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentText.backgroundColor = UIColor(red:0.19, green:0.32, blue:0.57, alpha:0.2)
        contentText.textColor = UIColor(red:0.19, green:0.32, blue:0.57, alpha:0.9)
        contentText.font = UIFont.systemFont(ofSize: 18)
        return contentText
    }()
    
    let locationTextField: UITextField =
    {
        let titleText = UITextField(title: "Location", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.35))
        return titleText
    }()
    
    let selectLocationButton: UIButton =
    {
        let button = UIButton(title: "Search Location", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.6))
        button.addTarget(self, action: #selector(handleSelectLoc), for: .touchUpInside)
        return button
    }()
    
    let bothImages: UIView =
    {
        let bothImg = UIView()
        bothImg.backgroundColor = UIColor.red
        return bothImg
    }()
    
    let addedImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default-image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let submitButton: UIButton =
    {
        let button = UIButton(title: "Submit", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.6))
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews()
    {
        //Configure the button
        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("Category", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //Set the drop down menu's options
        button.dropView.dropDownOptions = ["Study", "Travel", "Food", "Special"]
        
        // stackview
        let stackView = createStackView(views: [titlePostTextField, locationTextField, selectLocationButton,  postDescTextField, submitButton])
        
        self.addSubview(backgroundImageView)
        self.addSubview(addedImageView)
        self.insertSubview(button, aboveSubview: backgroundImageView)
        self.insertSubview(stackView, aboveSubview: button)

        backgroundImageView.setAnchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        addedImageView.setAnchor(width: 100, height: 100)
        addedImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        addedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadProfileImage)))
        addedImageView.isUserInteractionEnabled = true
        
        button.setAnchor(width: self.frame.width - 160, height: 30)
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.setAnchor(width: self.frame.width - 160, height: 320)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // Vertical Constraints
        addConstraintsWithFormat(format: "V:|-120-[v0]-5-[v1]-8-[v2]", views: addedImageView, button, stackView)
    }
    
    @objc func handleSubmit()
    {
        submitAction?()
    }
    
    @objc func handleSelectLoc()
    {
        selectLocationAction?()
    }
    
    @objc func handleUploadProfileImage()
    {
        uploadImageAction?()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}
