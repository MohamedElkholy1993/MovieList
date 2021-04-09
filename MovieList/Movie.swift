//
//  Movie.swift
//  MovieList
//
//  Created by moutaz hegazy on 3/8/21.
//  Copyright © 2021 Mohmaed_Elkholy. All rights reserved.
//

import UIKit
import CoreData

class Movie:  Codable {
    var title :String
    var image :String
    var rating:Float
    var releaseYear:Int
    var genre :[String]
    
     init() {
       
        self.title = "Title"
        self.image = "Image"
        self.rating = 0
        self.releaseYear = 2020
        self.genre = []
    }
    init(withMovieEntity movieEntity:MovieEntity) {
        self.title = movieEntity.title!
        self.image = movieEntity.image!
        self.rating = movieEntity.rating
        self.releaseYear = Int(truncating: movieEntity.releaseYear!)
        self.genre = []
        for genre in movieEntity.genre!
        {
            if let element = genre as? GenreEntity{
                self.genre.append(element.genre!)
            }
        }
    }
//    init(withTitle title:String,andImageNamed imageName:String,andRating rating:Float,andReleaseYear releaseYear:Int,andGenre genre:[String]) {
//        self.title = title
//        self.image = imageName
//        self.rating = rating
//        self.releaseYear = releaseYear
//        self.genre = genre
//    }
//    init(withDictionary dictionary: Dictionary<String,Any>) {
//        self.title = dictionary["title"] as! String
//        self.image = dictionary["image"] as! String
//        self.rating = Float(truncating: dictionary["rating"] as! NSNumber)
//        self.releaseYear = Int(truncating: dictionary["releaseYear"] as! NSNumber)
//        self.genre = dictionary["genre"] as! Array<String>
//    }
    
}
