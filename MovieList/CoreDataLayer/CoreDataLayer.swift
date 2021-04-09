//
//  CoreDataLayer.swift
//  MovieList
//
//  Created by moutaz hegazy on 3/11/21.
//  Copyright © 2021 Mohmaed_Elkholy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataLayer{
    static var sharedInstance = CoreDataLayer()
    
    
    func saveToStorage(movie:Movie){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let newMovie = MovieEntity(context: managedContext)
        newMovie.title = movie.title
        newMovie.image = movie.image
        newMovie.releaseYear = NSDecimalNumber(value: movie.releaseYear )
        newMovie.rating = movie.rating
        
        for genre in movie.genre
        {
            let newGenre = GenreEntity(context: managedContext)
            newGenre.genre = genre
            newMovie.addToGenre(newGenre)
        }
        do{
            try managedContext.save()
        }catch let error{
            print(error)
        }
    }
    
    
    func getDataFromStorage(completionHandler: @escaping ([Movie]?,[MovieEntity]?,Error?) -> Void){
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                    do{
                        let movieEntities = try managedContext.fetch(fetchRequest)
                        var movies = [Movie]()
                        for movieEntity in movieEntities
                        {
                            let newMovie = Movie.init(withMovieEntity: movieEntity)
                            movies.append(newMovie)
                        }
                        completionHandler(movies,movieEntities,nil)

                    }catch let error{
                        completionHandler(nil,nil,error)
                        print(error)
                    }
                }
            }
        }
    
    
        
    func deleteFromStorage(from movies: inout [MovieEntity],at index:Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(movies[index])
        movies.remove(at: index)
        do{
            try managedContext.save()
        }catch let error{
            print(error)
        }
    }
    
    
    func deleteAllDataFromStorage(from movies: inout [MovieEntity])
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do{
            let movieEntities = try managedContext.fetch(fetchRequest)
            
            for movieEntity in movieEntities
            {
                managedContext.delete(movieEntity)
            }
            
        }catch let error{
            print(error)
        }
        
    }
}
