//
//  GenreEntity+CoreDataProperties.swift
//  
//
//  Created by moutaz hegazy on 3/11/21.
//
//

import Foundation
import CoreData


extension GenreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreEntity> {
        return NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
    }

    @NSManaged public var genre: String?
    @NSManaged public var movie: MovieEntity?

}
