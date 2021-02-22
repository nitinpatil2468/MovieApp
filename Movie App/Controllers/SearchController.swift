//
//  SearchController.swift
//  Movie App
//
//  Created by Nitin Patil on 17/02/21.
//

import Foundation
import UIKit

class SearchController: UIViewController{
    
    
    lazy var collectionView:UICollectionView = {
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.showsVerticalScrollIndicator = false
    cv.setCollectionViewLayout(layout, animated: false)
    cv.delegate = self
    cv.dataSource = self
    cv.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
    cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    return cv
}()
    
    
    lazy var searchController:UISearchController = {
        let sb = UISearchController(searchResultsController: nil)
        sb.dimsBackgroundDuringPresentation = false // Optional
        sb.searchBar.delegate = self
        sb.hidesNavigationBarDuringPresentation = false
        return sb
}()
    
    var searchTask: DispatchWorkItem?

    var MoviesList = [Movie]()
    var filterOption = ""
    var pages : Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureUI()
        fetchMoreDetails()

    }
    
    func configureUI(){
 
        navigationItem.searchController = searchController
        self.navigationItem.title = "Movie"

        
        self.view.addSubview(collectionView)

        collectionView.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)


    }
    
}

extension SearchController : UISearchBarDelegate {
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        filterOption = searchText
        if searchText == ""{
            MoviesList.removeAll()
            collectionView.reloadData()

        }else{
            self.searchTask?.cancel()
            MoviesList.removeAll()

            let task = DispatchWorkItem{
                
                [weak self] in
                self?.fetchMoreDetails()
            }
            self.searchTask = task
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
        }
    }
    
}


extension SearchController : UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return MoviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        cell.data = MoviesList[indexPath.row]
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width / 2 - 2, height: width / 2 - 2)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = MovieDetailsController()
        vc.movieDetails = MoviesList[indexPath.row]
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if (indexPath.row == MoviesList.count - 1 ) { //it's your last cell
           //Load more data & reload your collection view
            pages = pages + 1
            fetchMoreDetails()
         }
    }
    
    func fetchMoreDetails() {
        
        let APIRequest = "https://api.themoviedb.org/3/search/movie?api_key=\(Constant.APIKey)&query=\(filterOption)&page=\(pages)"

        guard let url = URL(string: APIRequest) else { return}
        
        
        NetworkRequestHandler.shared.GET(url:url, completion: {(responseString , error) in
            if let xmlString = responseString{
                if let array = xmlString["results"] as? [[AnyHashable : Any]]{
                    for dict in array{
                        let v = Movie(_dict: dict)
                        self.MoviesList.append(v)
                    }
                    print("count:\(self.MoviesList.count)")

                    self.collectionView.reloadData()
                }
            }else if let error = error{
                print (error.localizedDescription as Any);

            }
        })
    }
    
}

  
    




