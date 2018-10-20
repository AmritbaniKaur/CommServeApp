//
//  HomeViewCollection.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 4/29/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit
import Firebase

// Base Feed Cell Class
class HomeViewCollection: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    var postRef = Database.database().reference().child("posts")
    var favRef = Database.database().reference().child("pinned")
    var checkRef = Database.database().reference().child("completed")

    var userPost: UserPost?
    var postArray = [UserPost]()
    var favArray = [UserPost]()
    var checkArray = [UserPost]()
    
    lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    
    func fetchData()//_ animated: Bool)
    {
        // download reviews
        let tempCategory = "Study"
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
    
    override func setupViews()
    {
        super.setupViews()
        
        fetchData()
        
        backgroundColor = UIColor(red:0.99, green:0.67, blue:0.22, alpha:1.0)
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|-100-[v0]-100-|", views: collectionView)
        
        collectionView.register(SinglePostCell.self, forCellWithReuseIdentifier: "homeSubViewCellId")

        self.collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeSubViewCellId", for: indexPath) as! SinglePostCell
        
        let postId = postArray[indexPath.row].postId!
        let postTitle = postArray[indexPath.row].postTitle!
        let postDesc = postArray[indexPath.row].postDesc!
        let postedUserId = postArray[indexPath.row].userId!
        let postedUserName = postArray[indexPath.row].userName!
        let postedLocation = postArray[indexPath.row].postLocation!
        let category = postArray[indexPath.row].postCategory!
        let imageUrl = postArray[indexPath.row].imageUrl
        
        cell.titleLabel.text = postTitle
        cell.locationLabel.text = "At: " + postedLocation
        cell.descLabel.text = postDesc
        cell.postedUserLabel.text = "Posted By: " + postedUserName
        
        
        if imageUrl == nil
        {
            cell.thumbnailImageView.image = UIImage(named: "default-image")//loadImageUsingCacheWithUrlString(imageUrl!)
        }
        else
        {
            self.getImageFromWeb(imageUrl!) { (image) in
                if let image = image
                {
                    cell.thumbnailImageView.image = image
                } // if you use an Else statement, it will be in background
            }
        }
        
        // Pinned Posts
        let tempUserId = Auth.auth().currentUser?.uid // else { return 0 }
        cell.pinnedView.setImage(UIImage(named: "Unpin"), for: .normal)
        cell.pinnedView.setImage(UIImage(named: "Pinned"), for: .selected)
        
        // Maintaining the Button State
        self.favRef.child(tempUserId!).observe(.value, with: {(snapshot) in
            
            if snapshot.hasChild(postId)
            {
                cell.pinnedView.setImage(UIImage(named: "Pinned"), for: .normal)
                cell.pinnedView.isSelected = true
            }
            else
            {
                cell.pinnedView.setImage(UIImage(named: "Unpin"), for: .normal)
                cell.pinnedView.isSelected = false
            }
        })
        
        cell.pinnedView.addTarget(self, action: #selector(self.handlePinClick), for: .touchUpInside)
        cell.pinnedView.tag = indexPath.row
        
        
        // Checked Posts
        cell.checkedView.setImage(UIImage(named: "check"), for: .selected)
        cell.checkedView.setImage(UIImage(named: "uncheck"), for: .normal)
        
        cell.checkedView.addTarget(self, action: #selector(self.handleCheckClick), for: .touchUpInside)
        cell.checkedView.tag = indexPath.row
        
        
        // Background of the cell
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "cell-background")
        backImageView.contentMode = .scaleToFill
        cell.backgroundView = backImageView
        
        return cell
    }
    
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ())
    {
        guard let url = URL(string: urlString) else
        {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response")
                return closure(nil)
            }
            guard data != nil else {
                print("no data")
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }; task.resume()
    }
    
    @objc func handleCheckClick(sender: UIButton)
    {
        let indexRow = sender.tag
        let tempPostCat = String(self.postArray[indexRow].postCategory!)
        
        if(sender.isSelected == false)
        {
            sender.isSelected = false
            
            guard let tempUserId = Auth.auth().currentUser?.uid else { return }

            /////////////////////////////////////////////////////
            // add it in Checked database
            // Reflect in the database
            let postId = self.postArray[indexRow].postId!
            let title = self.postArray[indexRow].postTitle!
            let desc = self.postArray[indexRow].postDesc!
            let postCategory = self.postArray[indexRow].postCategory!
            let location = self.postArray[indexRow].postLocation!
            let imageUrl = self.postArray[indexRow].imageUrl!
            let usrnm = self.postArray[indexRow].userName!
            let userId = self.postArray[indexRow].userId!
            
            let values: [String: Any] = [
                "completedBy" : tempUserId,
                "postId" : postId,
                "postTitle" : title,
                "postDesc" : desc,
                "postCategory" : postCategory,
                "postLocation" : location,
                "imageUrl" : imageUrl,
                "userName" : usrnm,
                "userId" : userId,
                ]
            
            let checkReference = checkRef.child(postId)//.child(tempReviewUserId)
            checkReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err ?? "")
                    return
                }
            })

            /////////////////////////////////////////////////////
            // Delete from Post database
            // Reflect in the database
            let tempPostId = String(self.postArray[indexRow].postId!)

            postRef.child(tempPostCat).child(tempPostId).removeValue()
            self.collectionView.reloadData()
            
        }

    }
    
    @objc func handlePinClick(sender: UIButton)
    {
        guard let tempUserId = Auth.auth().currentUser?.uid else { return }
        
        let indexRow = sender.tag
        
        if(sender.isSelected == true)
        {
            print("Unpinned")
            sender.isSelected = false
            
            // Reflect in the database
            let tempPostId = String(self.postArray[indexRow].postId!)
            
            favRef.child(tempUserId).child(tempPostId).removeValue()
            self.collectionView.reloadData()
        }
        else
        {
            print("Pinned")
            sender.isSelected = true
            
            // Reflect in the database
            let postId = self.postArray[indexRow].postId!
            let title = self.postArray[indexRow].postTitle!
            let desc = self.postArray[indexRow].postDesc!
            let postCategory = self.postArray[indexRow].postCategory!
            let location = self.postArray[indexRow].postLocation!
            let imageUrl = self.postArray[indexRow].imageUrl!
            let usrnm = self.postArray[indexRow].userName!
            let userId = self.postArray[indexRow].userId!
            
            let values: [String: Any] = [
                "postId" : postId,
                "postTitle" : title,
                "postDesc" : desc,
                "postCategory" : postCategory,
                "postLocation" : location,
                "imageUrl" : imageUrl,
                "userName" : usrnm,
                "userId" : userId,
                ]
            
            let favReference = favRef.child(tempUserId).child(postId)//.child(tempReviewUserId)
            favReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err ?? "")
                    return
                }
            })
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSize(width: frame.width, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
}

class SinglePostCell: BaseCell
{
    let thumbnailImageView: UIImageView =
    {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "default-image")
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let pinnedView: UIButton =
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Unpin"), for: .normal)
        btn.setImage(UIImage(named: "Pinned"), for: .selected)
        return btn
    }()
    
    let checkedView: UIButton =
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: "uncheck"), for: .normal)
        btn.setImage(UIImage(named: "check"), for: .selected)
        return btn
    }()
    
    let separatorView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255,  alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Post Title"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    let descLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Post Description"
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Post Location"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    let postedUserLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Posted User"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews()
    {
        super.setupViews()
        
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(locationLabel)
        addSubview(postedUserLabel)
        addSubview(thumbnailImageView)
        addSubview(checkedView)
        addSubview(pinnedView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(175)]", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(175)]", views: locationLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(175)]", views: descLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(175)]", views: postedUserLabel)
        addConstraintsWithFormat(format: "H:[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:[v0]-30-|", views: checkedView)
        addConstraintsWithFormat(format: "H:[v0]-116-|", views: pinnedView)

        // Vertical Constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-5-[v1]-8-[v2]-8-[v3]-16-|", views: titleLabel, descLabel, locationLabel, postedUserLabel)
        addConstraintsWithFormat(format: "V:[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "V:|-14-[v0]", views: checkedView)
        addConstraintsWithFormat(format: "V:|-6-[v0]", views: pinnedView)

        ////////////////////////////////////////////////////////////////////////////////
        // ThumbnailImageView
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 16))
        // Height Constraint
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 130))
        // Width Constraint
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 130))
        
        ////////////////////////////////////////////////////////////////////////////////
        // checkedView
        // Height Constraint
        addConstraint(NSLayoutConstraint(item: checkedView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        // Width Constraint
        addConstraint(NSLayoutConstraint(item: checkedView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 20))
        
        ////////////////////////////////////////////////////////////////////////////////
        // pinnedView
        // Height Constraint
        addConstraint(NSLayoutConstraint(item: pinnedView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 38))
        // Width Constraint
        addConstraint(NSLayoutConstraint(item: pinnedView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 30))
    }

}

class BaseCell: UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews()
    {
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
