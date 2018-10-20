//
//  AppUser.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/29/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import Foundation
import Firebase

struct AppUser
{
    var username: String?
    var uid: String?
    var email: String?
    var profileurl: String?
    var country: String?
    var phone: String?
    var karmaPoints: Int?
    
    let ref: DatabaseReference!

    init(snapshot: DataSnapshot)
    {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any]
        {
            username = value["username"] as! String!
            uid = value["uid"] as! String!
            email = value["email"] as! String!
            profileurl = value["profileurl"] as! String!
            country = value["country"] as! String!
            phone = value["phone"] as! String!
            karmaPoints = value["karmaPoints"] as! Int!
        }
    }
    
    init(username: String, uid: String, email: String, profileurl: String, country: String, phone: String, karmaPoints: Int)
    {
        self.username = username
        self.uid = uid
        self.email = email
        self.profileurl = profileurl
        self.country = country
        self.phone = phone
        self.karmaPoints = karmaPoints
        ref = Database.database().reference().child("users").childByAutoId()
    }
}


