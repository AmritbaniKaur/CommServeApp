//
//  WelcomeViewCollection.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/28/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

struct WelcomePage
{
    let imageName: String
    let header: String
    let body: String
    
}

class WelcomeViewCollection: UICollectionViewCell
{
    var getStartedAction: (() -> Void)?

    private let welcomeImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "default-image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let headerTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        let attributedText = NSMutableAttributedString(string: "Welcome Default Header!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        let attributedText = NSAttributedString(string: "\n\n\nSomething is wrong (body)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.gray])
        
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let getStartedButton: UIButton =
    {
        let button = UIButton(title: "Start Helping!", borderColor: UIColor(red: 60/255, green: 10/255, blue: 115/255, alpha: 0.35))
        button.addTarget(self, action: #selector(handleGetStarted), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    

    @objc func handleGetStarted()
    {
        getStartedAction?()
    }
    
    var page: WelcomePage?
    {
        didSet {
            // optionals -> unwrapping, data change
            guard let unwrappedPage = page else { return }
            welcomeImageView.image = UIImage(named: unwrappedPage.imageName)
            
            let headerAttributedText = NSMutableAttributedString(string: unwrappedPage.header, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
            
            let bodyAttributedText = NSAttributedString(string: unwrappedPage.body.uppercased(), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black])
            
            headerTextView.attributedText = headerAttributedText
            headerTextView.textAlignment = .center
            
            bodyTextView.attributedText = bodyAttributedText
            bodyTextView.textAlignment = .center
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout()
    {
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        // auto layout constraints
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        topImageContainerView.addSubview(welcomeImageView)
        
        welcomeImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        welcomeImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        welcomeImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.7).isActive = true
        
        let bottomContainerView = UIView()
        addSubview(bottomContainerView)
        
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        addSubview(bottomContainerView)
        
        bottomContainerView.addSubview(headerTextView)
        bottomContainerView.addSubview(bodyTextView)
        bottomContainerView.addSubview(getStartedButton)

        headerTextView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        headerTextView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 30).isActive = true
        headerTextView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -30).isActive = true
        headerTextView.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor, multiplier: 0.2).isActive = true
        
        bodyTextView.topAnchor.constraint(equalTo: headerTextView.bottomAnchor, constant: 10).isActive = true
        bodyTextView.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        bodyTextView.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor, multiplier: 0.2).isActive = true
        bodyTextView.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.9).isActive = true
        
        getStartedButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 10).isActive = true
        getStartedButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        getStartedButton.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor, multiplier: 0.1).isActive = true
        getStartedButton.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}
