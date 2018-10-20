//
//  PinViewCollection.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/4/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

class PinViewCollection: UITableViewCell
{
    // link between table view row cell and table view controller
    var link: PinController?
    
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

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupViews()
    {
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}
