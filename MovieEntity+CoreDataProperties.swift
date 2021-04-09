//
//  MovieEntity+CoreDataProperties.swift
//  
//
//  Created by moutaz hegazy on 3/11/21.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var image: String?
    @NSManaged public var rating: Float
    @NSManaged public var releaseYear: NSDecimalNumber?
    @NSManaged public var title: String?
    @NSManaged public var genre: NSSet?

}

// MARK: Generated accessors for genre
extension MovieEntity {

    @objc(addGenreObject:)
    @NSManaged public func addToGenre(_ value: GenreEntity)

    @objc(removeGenreObject:)
    @NSManaged public func removeFromGenre(_ value: GenreEntity)

    @objc(addGenre:)
    @NSManaged public func addToGenre(_ values: NSSet)

    @objc(removeGenre:)
    @NSManaged public func removeFromGenre(_ values: NSSet)

}
