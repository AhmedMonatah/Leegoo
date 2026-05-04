//
//  FavoriteLeague.swift
//  Leegoo
//
//  Created by TaqieAllah on 04/05/2026.
//

import Foundation
import CoreData

@objc(FavoriteLeague)
public class FavoriteLeague: NSManagedObject {

}

extension FavoriteLeague {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteLeague> {
        NSFetchRequest<FavoriteLeague>(entityName: "FavoriteLeague")
    }

    @NSManaged public var leagueKey: Int64
    @NSManaged public var leagueName: String?
    @NSManaged public var leagueLogo: String?
    @NSManaged public var sportName: String?
    @NSManaged public var countryName: String?
}

extension FavoriteLeague: Identifiable {

}
