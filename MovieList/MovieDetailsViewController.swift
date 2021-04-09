//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by moutaz hegazy on 3/8/21.
//  Copyright © 2021 Mohmaed_Elkholy. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class MovieDetailsViewController: UIViewController {

    var movieToView = Movie()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var releaseYearLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var genreLabel: UILabel?
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel?.text = movieToView.title
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        if let url = URL(string: movieToView.image){
            activityIndicator.startAnimating()
            
            imageView?.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if error != nil {
                        self.imageView?.image = UIImage(named: "Image")
                    }
                }
            })
        }
        
        releaseYearLabel?.text = "Release Year: "+String(movieToView.releaseYear)
        ratingLabel?.text = "Ratring: "+String(movieToView.rating)
        ratingStars.settings.updateOnTouch = false
        ratingStars.rating = Double(movieToView.rating/2)
        genreLabel?.text = "Genre: "
        for item in movieToView.genre
        {
            genreLabel?.text! += item+" "
        }
        
        
    }
    

    
}
