//
//  ViewController.swift
//  Movie App
//
//  Created by Nitin Patil on 17/02/21.
//

import UIKit

class HomeController: UIViewController {
    
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
    
    let TitleLabel:UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.text = "Movies"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var filterButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.setTitle("Now Playing", for: .normal)
        btn.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        btn.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    
    
    var MoviesList = [Movie]()
    var filterOption = "now_playing"
    var pages : Int = 1
    
    

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureUI()
        fetchMoreDetails()

    }
    
    func configureUI(){

        
        navigationController?.navigationBar.isHidden = true
        self.view.addSubview(TitleLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(filterButton)

        TitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10)
        collectionView.anchor(top: TitleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        filterButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 10,  paddingRight: 10,width: 150)


    }
    
    @objc func showOptions(){
        let alert = UIAlertController(title: "Select One", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Now Playing", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.MoviesList.removeAll()
            self.filterOption = "now_playing"
            self.filterButton.setTitle("Now Playing", for: .normal)
            self.fetchMoreDetails()
        }))
        
        alert.addAction(UIAlertAction(title: "Popular", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.MoviesList.removeAll()
            self.filterOption = "popular"
            self.filterButton.setTitle("Popular", for: .normal)
            self.fetchMoreDetails()
        }))
        
        alert.addAction(UIAlertAction(title: "Top Rated", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.MoviesList.removeAll()
            self.filterOption = "top_rated"
            self.filterButton.setTitle("Top Rated", for: .normal)
            self.fetchMoreDetails()
        }))
        
        alert.addAction(UIAlertAction(title: "Upcoming", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.MoviesList.removeAll()
            self.filterOption = "upcoming"
            self.filterButton.setTitle("Upcoming", for: .normal)
            self.fetchMoreDetails()
        }))
       self.present(alert, animated: true, completion: nil)
    }
}


extension HomeController : UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout{
    
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
        
        print("pages:\(pages)")

        
        let APIRequest = "https://api.themoviedb.org/3/movie/\(filterOption)?api_key=\(Constant.APIKey)&page=\(pages)"
        let url = URL(string: APIRequest)
        
        
        NetworkRequestHandler.shared.GET(url:url!, completion: {(responseString , error) in
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

  
    



