//
//  LazyImageView.swift
//  Movie App
//
//  Created by Nitin Patil on 17/02/21.
//

import Foundation
import UIKit
import Kingfisher

class LazyImageView : UIImageView{
    
    let imageCache = NSCache<AnyObject,UIImage>()
    func loadImage(imageUrl : URL){
        
        self.image = UIImage(named: "loader.png")
        
        self.kf.indicatorType = .activity
        let imgResource = ImageResource(downloadURL: imageUrl, cacheKey: imageUrl.absoluteString)
        self.kf.setImage(with: imgResource, placeholder: nil, options: [.transition(.fade(0.7))], completionHandler: nil)
        
//        if let cacheImage = self.imageCache.object(forKey: imageUrl as AnyObject){
//            self.image = cacheImage
//            return
//        }
//
//        DispatchQueue.global().async{
//            [weak self] in
//            if let imgData = try? Data(contentsOf: imageUrl){
//                if let img = UIImage(data: imgData){
//                    DispatchQueue.main.async {
//                        self?.imageCache.setObject(img, forKey: imageUrl as AnyObject)
//                        self?.image = img
//                    }
//                }
//            }
//        }
    }
}

