//
//  MovieEntity+CoreDataProperties.swift
//  MovieProject
//
//  Created by kuldeep Singh on 03/03/25.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var posterPath: String?

}

extension MovieEntity : Identifiable {

}
