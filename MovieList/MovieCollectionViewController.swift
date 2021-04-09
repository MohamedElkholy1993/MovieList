//
//  MovieCollectionViewController.swift
//  MovieList
//
//  Created by moutaz hegazy on 3/15/21.
//  Copyright © 2021 Mohmaed_Elkholy. All rights reserved.
//

import UIKit
import CoreData
import Network
import SDWebImage
import Reachability

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    var movies:[Movie] = []
    var movieEntities :[MovieEntity] = []
    var url = "http://api.androidhive.info/json/movies.json"
    let monitor = NWPathMonitor()
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movies List"
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                //Online Mode
                
                
                //fetch data from api
                
                NetworkLayer.sharedInstance.getDataFromJSON(url: self.url) {[weak self](data,respose,error) in
                    guard let weakSelf = self else {return}
                    do{
                        //parsing with codable
                        if let safeData = data{
                            let decoder = JSONDecoder()
                            do {
                                let decodedData = try decoder.decode(Array<Movie>.self, from: safeData)
                                weakSelf.movies = decodedData
                            }
                        }else{
                            print("error fetching data!")
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            //fetch data from CoreData
                            CoreDataLayer.sharedInstance.getDataFromStorage(){[weak self](movies,movieEntities,error) in
                                guard let weakSelf = self else {return}
                                if error == nil {
                                    weakSelf.movies += movies!
                                    weakSelf.movieEntities += movieEntities!
                                    weakSelf.collectionView.reloadData()
                                }else{
                                    print(error!)
                                }
                                
                            }
                            
                            
                        }
                    }catch {
                        print(error)
                    }
                    
                }
                
            } else {
                //Offline Mode
                
                //fetch data from CoreData
                CoreDataLayer.sharedInstance.getDataFromStorage(){[weak self](movies,movieEntities,error) in
                    guard let weakSelf = self else {return}
                    if error == nil {
                        weakSelf.movies += movies!
                        weakSelf.movieEntities += movieEntities!
                        
                    }else{
                        print(error!)
                    }
                    
                }
            }
            
            
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

        
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
    
        // Configure the cell
        
        cell.layer.cornerRadius = 20.0
        cell.layer.borderWidth  = 1.0
        cell.layer.borderColor  = UIColor.white.cgColor
        
        if let url = URL(string: movies[indexPath.row].image){
            cell.activityIndicator.startAnimating()
            
            cell.movieImageView?.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    if error != nil {
                        cell.movieImageView?.image = UIImage(named: "Image")
                    }
                }
            })
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsViewController
        vc.movieToView = movies[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 130, height: 130)
        return size
    }
    

}

