//
//  MovieCell.swift
//  Movie App
//
//  Created by Nitin Patil on 07/01/21.
//

import UIKit
import Photos

class MovieCell: UICollectionViewCell {

    var data:Movie?{
        didSet{
            manageData()
        }
    }

    let cardImage:LazyImageView = {
        let img = LazyImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
 
    let label:UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.text = "Titanic"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 4
        clipsToBounds = true

        addSubview(cardImage)
        addSubview(label)
        cardImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        label.centerX(inView: cardImage)
        label.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingLeft: 7, paddingBottom: 5, paddingRight: -5, height: 30)

    }

    
    func manageData(){
        guard let data = data else {return}
        let url = URL(string:data.getPosterPath()!)
        cardImage.loadImage(imageUrl: url!)
        label.text = data.getTitle()
    }
}
