//
//  UserPost.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/2/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import Foundation
import Firebase

struct UserPost
{
    var postDesc: String?
    var postId: String?
    var postTitle: String?
    var userId: String?
    var userName: String?
    var postCategory: String?
    var postLocation: String?
    var imageUrl: String?
    
    let ref: DatabaseReference!

    init(postDesc: String, postId: String, postTitle: String, postCategory: String, postLocation: String, userId: String, userName: String, imageUrl: String)
    {
        self.postDesc = postDesc
        self.postId = postId
        self.postTitle = postTitle
        self.postCategory = postCategory
        self.postLocation = postLocation
        self.userId = userId
        self.userName = userName
        self.imageUrl = imageUrl
        ref = Database.database().reference().child("posts").childByAutoId()
    }
    
    init(snapshot: DataSnapshot)
    {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any]
        {
            postDesc = value["postDesc"] as! String!
            postId = value["postId"] as! String!
            postTitle = value["postTitle"] as! String!
            postCategory = value["postCategory"] as! String!
            postLocation = value["postLocation"] as! String!
            userId = value["userId"] as! String!
            userName = value["userName"] as! String!
            imageUrl = value["imageUrl"] as! String!
        }
    }
    
    func save()
    {
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String: Any]
    {
        return
            [
                "postDesc" : postDesc,
                "postId" : postId,
                "postTitle" : postTitle,
                "postCategory" : postCategory,
                "postLocation" : postLocation,
                "userId" : userId,
                "userName" : userName,
                "imageUrl" : imageUrl
        ]
    }
}


struct CheckPost
{
    var postDesc: String?
    var postId: String?
    var postTitle: String?
    var userId: String?
    var userName: String?
    var postCategory: String?
    var postLocation: String?
    var imageUrl: String?
    var completedBy: String?
    
    let ref: DatabaseReference!
    
    init(postDesc: String, postId: String, postTitle: String, postCategory: String, postLocation: String, userId: String, userName: String, imageUrl: String, completedBy: String)
    {
        self.postDesc = postDesc
        self.postId = postId
        self.postTitle = postTitle
        self.postCategory = postCategory
        self.postLocation = postLocation
        self.userId = userId
        self.userName = userName
        self.imageUrl = imageUrl
        self.completedBy = completedBy

        ref = Database.database().reference().child("completed").childByAutoId()
    }
    
    init(snapshot: DataSnapshot)
    {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any]
        {
            postDesc = value["postDesc"] as! String!
            postId = value["postId"] as! String!
            postTitle = value["postTitle"] as! String!
            postCategory = value["postCategory"] as! String!
            postLocation = value["postLocation"] as! String!
            userId = value["userId"] as! String!
            userName = value["userName"] as! String!
            imageUrl = value["imageUrl"] as! String!
            completedBy = value["completedBy"] as! String!

        }
    }
    
    func save()
    {
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String: Any]
    {
        return
            [
                "postDesc" : postDesc,
                "postId" : postId,
                "postTitle" : postTitle,
                "postCategory" : postCategory,
                "postLocation" : postLocation,
                "userId" : userId,
                "userName" : userName,
                "imageUrl" : imageUrl,
                "completedBy" : completedBy
        ]
    }
}

