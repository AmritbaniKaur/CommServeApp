//
//  Extensions.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/1/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView
{
    func loadImageUsingCacheWithUrlString(_ urlString: String)
    {
        self.image = nil
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            //download hit an error so lets return out
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}

extension UIView
{
    func addConstraintsWithFormat(format: String, views : UIView...)
    {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated()
        {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UITextView
{
    public convenience init(title: String, borderColor: UIColor)
    {
        self.init()
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        
        let light_gray = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 0.3)
        self.layer.backgroundColor = light_gray.cgColor
        self.backgroundColor = light_gray

        self.textColor = UIColor(white: 1, alpha: 1)
        self.font = UIFont.systemFont(ofSize: 18)
        self.backgroundColor = .clear
        self.autocorrectionType = .no
        self.setAnchor(width: 0, height: 40)
    }
}

extension UIView
{
    func createStackView(views: [UIView]) -> UIStackView
    {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }
}

extension UIButton
{
    public convenience init(title: String, borderColor: UIColor)
    {
        self.init()
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.white]))
        self.setAttributedTitle(attributedString, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.backgroundColor = UIColor(red:0.19, green:0.32, blue:0.57, alpha:0.5).cgColor
        self.layer.borderColor = borderColor.cgColor
        self.setAnchor(width: 0, height: 30)
    }
}

extension UITextField
{
    public convenience init(title: String, borderColor: UIColor)
    {
        self.init()
        
        self.borderStyle = .none
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red:0.19, green:0.32, blue:0.57, alpha:0.1)
        self.borderStyle = UITextBorderStyle.roundedRect // .bezel
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        
        self.textColor = UIColor(red:0.19, green:0.32, blue:0.57, alpha:0.7)
        self.font = UIFont.systemFont(ofSize: 17)
        self.autocorrectionType = .no
        // placeholder
        var placeholder = NSMutableAttributedString()
        placeholder = NSMutableAttributedString(attributedString: NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(red:0.19, green:0.32, blue:0.57, alpha:0.75)]))
        self.attributedPlaceholder = placeholder
        self.setAnchor(width: 0, height: 30)
        self.setLeftPaddingPoints(10)
    }
    
    func setLeftPaddingPoints(_ space: CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y:0, width: space, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIView
{
    func setAnchor(width: CGFloat, height: CGFloat)
    {
        self.setAnchor(top:nil, left: nil, bottom: nil, right: nil, paddingTop:0, paddingLeft:0, paddingBottom:0, paddingRight:0,  width: width, height: height)
    }
    
    func setAnchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat = 0, height: CGFloat = 0)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top
        {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left
        {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom
        {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right
        {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if width != 0
        {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0
        {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, *)
        {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor
    {
        if #available(iOS 11.0, *)
        {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, *)
        {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor
    {
        if #available(iOS 11.0, *)
        {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
}

extension UIColor
{
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UITextFieldDelegate
{
    func phoneMask(phoneTextField: UITextField, textField: UITextField, _ range: NSRange, _ string: String) -> (result: Bool, phoneNumber: String, maskPhoneNumber: String)
    {
        let oldString = textField.text!
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        //in numString only Numeric characters
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let numString = components.joined(separator: "")
        
        let length = numString.count
        let maxCharInPhone = 11
        
        if newString.count < oldString.count
        { //backspace to work
            if newString.count <= 2
            { //if now "+7(" and push backspace
                phoneTextField.text = ""
                return (false, "", "")
            } else {
                return (true, numString, newString) //will not in the process backspace
            }
        }
        
        if length > maxCharInPhone
        { // input is complete, do not add characters
            return (false, numString, newString)
        }
        var indexStart, indexEnd: String.Index
        var maskString = "", template = ""
        var endOffset = 0
        
        if newString == "+"
        { // allow add "+" if first Char
            maskString += "+"
        }
        //format +X(XXX)XXX-XXXX
        if length > 0
        {
            maskString += "+"
            indexStart = numString.index(numString.startIndex, offsetBy: 0)
            indexEnd = numString.index(numString.startIndex, offsetBy: 1)
            maskString += String(numString[indexStart..<indexEnd]) + "("
        }
        if length > 1
        {
            endOffset = 4
            template = ") "
            if length < 4 {
                endOffset = length
                template = ""
            }
            indexStart = numString.index(numString.startIndex, offsetBy: 1)
            indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
            maskString += String(numString[indexStart..<indexEnd]) + template
        }
        if length > 4
        {
            endOffset = 7
            template = "-"
            if length < 7 {
                endOffset = length
                template = ""
            }
            indexStart = numString.index(numString.startIndex, offsetBy: 4)
            indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
            maskString += String(numString[indexStart..<indexEnd]) + template
        }
        var nIndex: Int; nIndex = 7

        if length > nIndex
        {
            indexStart = numString.index(numString.startIndex, offsetBy: nIndex)
            indexEnd = numString.index(numString.startIndex, offsetBy: length)
            maskString += String(numString[indexStart..<indexEnd])
        }
        phoneTextField.text = maskString
        if length == maxCharInPhone
        {
            //dimiss kayboard
            phoneTextField.endEditing(true)
            return (false, numString, newString)
        }
        return (false, numString, newString)
    }
}
