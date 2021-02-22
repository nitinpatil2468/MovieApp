//
//  Movies.swift
//  Movie App
//
//  Created by Nitin Patil on 17/02/21.
//

import Foundation

class Movie {

    var Title : String?
    var Overview : String?
    var PosterPath : String?
    var Entries : [Movie]?
    var releaseDate: String?
    var moviesArray : [[AnyHashable : Any]]?
    var movieInfo : [AnyHashable : Any]?

    init(_dict : [AnyHashable : Any]){
        self.movieInfo = _dict
        self.createModel()
   }

    func createModel(){
        
        print(self.movieInfo)
        
        if let title = self.movieInfo?["title"] as? String{
            self.setTitle(title)
        }
        
        if let path = self.movieInfo?["poster_path"] as? String{
            self.setPosterPath(path)

        }
        
        if let overView = self.movieInfo?["overview"] as? String{
            self.setOverview(overView)

        }
        
        if let date = self.movieInfo?["release_date"] as? String{
            self.setDate(date)

        }
        
        
        
        
    }

    func setEntries(_ Entries:[Movie]){

       self.Entries = Entries;

   }
   
   public func getEntries()->[Movie]?{

       return Entries!;
   }

    func setTitle(_ Title:String){

       self.Title = Title;

   }
   
    func setOverview(_ Overview:String){

       self.Overview = Overview;

   }
   
    func setPosterPath(_ PosterPath:String){
   
        self.PosterPath = "\(Constant.IMAGE_BASE_PATH)\(PosterPath)";
   }
    
    func setDate(_ releaseDate:String){

        self.releaseDate = releaseDate;

   }

   public func getDate()->String?{

       return releaseDate;
   }

   public func getTitle()->String?{

       return Title;
   }
   
   public func getOverview()->String?{

       return Overview;
   }
    public func getPosterPath()->String?{

       return PosterPath;
   }
}
