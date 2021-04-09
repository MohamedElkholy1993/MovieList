//
//  MoviesTableViewController.swift
//  MovieList
//
//  Created by moutaz hegazy on 3/8/21.
//  Copyright © 2021 Mohmaed_Elkholy. All rights reserved.
//

import UIKit
import CoreData
import Network
import SDWebImage
import Reachability

class MoviesTableViewController: UITableViewController {
   
    @IBOutlet weak var networkStatusIcon: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
                self.networkStatusIcon.tintColor = UIColor.green
                
                //fetch data from api
                self.activityIndicator.startAnimating()
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
                                    weakSelf.tableView.reloadData()
                                }else{
                                    print(error!)
                                }
                                
                            }
                            
                            weakSelf.activityIndicator.stopAnimating()
                        }
                    }catch {
                        print(error)
                    }
                    
                }
                
            } else {
                //Offline Mode
                self.networkStatusIcon.tintColor = UIColor.red
                //fetch data from CoreData
                CoreDataLayer.sharedInstance.getDataFromStorage(){[weak self](movies,movieEntities,error) in
                    guard let weakSelf = self else {return}
                    if error == nil {
                        weakSelf.movies += movies!
                        weakSelf.movieEntities += movieEntities!
                        weakSelf.tableView.reloadData()
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
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell

        // Configure the cell...
        cell.layer.cornerRadius = 20.0
        cell.layer.borderWidth  = 1.0
        cell.layer.borderColor  = UIColor.white.cgColor
        cell.backgroundColor    = UIColor.black
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.text = movies[indexPath.row].title
        cell.ratingLabel.textColor = UIColor.white
        cell.ratingLabel.text = "Rating: "+String(movies[indexPath.row].rating)
        cell.releaseYearLabel.textColor = UIColor.white
        cell.releaseYearLabel.text = "Release Year: "+String(movies[indexPath.row].releaseYear)
        
        if let url = URL(string: movies[indexPath.row].image){
            cell.activityIndicator.startAnimating()
            
            cell.movieImage?.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    if error != nil {
                        cell.movieImage.image = UIImage(named: "Image")
                    }
                }
            })
        }
        

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsViewController
        vc.movieToView = movies[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (networkStatusIcon.tintColor == .red)
        {
            return true
        }else{
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            CoreDataLayer.sharedInstance.deleteFromStorage(from: &movieEntities, at: indexPath.row)
            movies.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditNewMovie") as! EditNewMovieViewController
        self.navigationController?.pushViewController(vc, animated: true)
        vc.dataSender = self
    }
    
    
}
    // MARK: - Delegation Implementaion
extension MoviesTableViewController:SendNewMovieEditedData{
    func sendNewMovieEditedDataBack(newEditedMovie: Movie) {
        
        movies.append(newEditedMovie)
        CoreDataLayer.sharedInstance.saveToStorage(movie: newEditedMovie)
        self.tableView.reloadData()
    }
    
}

