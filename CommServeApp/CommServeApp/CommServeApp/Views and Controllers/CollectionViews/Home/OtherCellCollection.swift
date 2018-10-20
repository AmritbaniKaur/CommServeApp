//
//  SpecialCellCollection.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/3/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import Foundation
import Firebase

class SpecialCell: HomeViewCollection
{
    override func fetchData()//_ animated: Bool)
    {
        // download reviews
        let tempCategory = "Special" //String(describing: movie!.id!)
        postRef.child(tempCategory).observe(.value, with: {(snapshot) in
            self.postArray.removeAll()
            
            for child in snapshot.children
            {
                let childSnapshot = child as! DataSnapshot
                let post = UserPost(snapshot: childSnapshot)
                self.postArray.insert(post, at: 0)
            }
            self.collectionView.reloadData()
        })
    }
}

class TravelCell: HomeViewCollection
{
    override func fetchData()//_ animated: Bool)
    {
        // download reviews
        let tempCategory = "Travel" //String(describing: movie!.id!)
        postRef.child(tempCategory).observe(.value, with: {(snapshot) in
            self.postArray.removeAll()
            
            for child in snapshot.children
            {
                let childSnapshot = child as! DataSnapshot
                let post = UserPost(snapshot: childSnapshot)
                self.postArray.insert(post, at: 0)
            }
            self.collectionView.reloadData()
        })
    }
}

class FoodCell: HomeViewCollection
{
    override func fetchData()//_ animated: Bool)
    {
        // download reviews
        let tempCategory = "Food" //String(describing: movie!.id!)
        postRef.child(tempCategory).observe(.value, with: {(snapshot) in
            self.postArray.removeAll()
            
            for child in snapshot.children
            {
                let childSnapshot = child as! DataSnapshot
                let post = UserPost(snapshot: childSnapshot)
                self.postArray.insert(post, at: 0)
            }
            self.collectionView.reloadData()
        })
    }
}

