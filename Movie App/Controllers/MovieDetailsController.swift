//
//  MovieDetailsController.swift
//  Movie App
//
//  Created by Nitin Patil on 07/01/21.
//

import UIKit

class MovieDetailsController: UIViewController {

    let cardImage:LazyImageView = {
        let img = LazyImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = 8
        return img
    }()

    let titleLabel:UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        label.textColor = UIColor.black
        return label
    }()


    let releaseDateLbl:UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textColor = UIColor.darkText
        return label
    }()

    let overviewLbl:UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.text = "Overview :"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let infoTv:UITextView = {
        let tv = UITextView()
        tv.clipsToBounds = true
        tv.font = UIFont(name: "HelveticaNeue", size: 18.0)
        tv.textColor = UIColor.darkText
        return tv
    }()



    var movieDetails : Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
     func configureUI(){
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(cardImage)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLbl)
        view.addSubview(overviewLbl)
        view.addSubview(infoTv)

        
        cardImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10,height: view.frame.height/2)
        titleLabel.anchor(top: cardImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 50)
        releaseDateLbl.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 3, paddingLeft: 10,height: 20)
        overviewLbl.anchor(top: releaseDateLbl.bottomAnchor, left: view.leftAnchor, paddingTop: 5, paddingLeft: 10,height: 30)
        infoTv.anchor(top: overviewLbl.bottomAnchor, left: view.leftAnchor,bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 3, paddingLeft: 10,paddingBottom:10, paddingRight: 10)
        
        let leftButton = UIBarButtonItem(title:"Back", style: .plain, target: self, action: #selector(dissmiss))
        navigationItem.leftBarButtonItem = leftButton

    }
    
    @objc func dissmiss(){
        self.dismiss(animated: true, completion: nil)
    }


     func setData(){
        guard let movieDetails = movieDetails else {
            return
        }
        titleLabel.text = movieDetails.getTitle()?.capitalized
        releaseDateLbl.text = "Released date: \(movieDetails.getDate() as! String)"
        infoTv.text = movieDetails.getOverview()
        let imgUrl = URL(string: movieDetails.getPosterPath()!)
        cardImage.loadImage(imageUrl: imgUrl!)
    }
}
