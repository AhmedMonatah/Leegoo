//
//  FavoriteLeague+CoreDataProperties.swift
//  Leegoo
//
//  Created by TaqieAllah on 04/05/2026.
//
//

import Foundation
import CoreData


extension FavoriteLeague {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteLeague> {
        return NSFetchRequest<FavoriteLeague>(entityName: "FavoriteLeague")
    }

    @NSManaged public var leagueKey: Int64
    @NSManaged public var leagueName: String?
    @NSManaged public var leagueLogo: String?
    @NSManaged public var sportName: String?

}

extension FavoriteLeague : Identifiable {

}
