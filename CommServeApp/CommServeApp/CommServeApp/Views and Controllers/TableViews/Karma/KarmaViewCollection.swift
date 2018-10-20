//
//  KarmaViewCollection.swift
//  CommServeApp
//
//  Created by Amritbani Sondhi on 5/6/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

class KarmaViewCollection: UITableViewCell
{
    // link between table view row cell and table view controller
    var link: KarmaController?
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Post Title"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
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
        addSubview(locationLabel)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(175)]", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(175)]", views: locationLabel)
        
        // Vertical Constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-5-[v1]-16-|", views: titleLabel, locationLabel)
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

