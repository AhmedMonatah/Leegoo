import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Leegoo")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data store: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveLeague(_ league: League, sportName: String) {
        guard let leagueKey = league.leagueKey else { return }

        if isLeagueFavorite(id: leagueKey) { return }

        let favorite = FavoriteLeague(context: context)
        favorite.leagueKey = Int64(leagueKey)
        favorite.leagueName = league.leagueName
        favorite.leagueLogo = league.leagueLogo
        favorite.sportName = sportName

        saveContext()
    }

    func fetchFavorites() -> [FavoriteLeagueItem] {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)

            return results.map {
               let league = League(
                    leagueKey: Int($0.leagueKey),
                    leagueName: $0.leagueName,
                    countryName: nil,
                    leagueLogo: $0.leagueLogo,
                    countryLogo: nil,
                    leagueYear: nil,
                    leagueSurface: nil
                )
                return FavoriteLeagueItem(
                        league: league,
                        sportName: $0.sportName ?? "football"
                )
            }
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
            return []
        }
    }

    func deleteLeague(id: Int) {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Failed to delete favorite: \(error.localizedDescription)")
        }
    }

    func isLeagueFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", id)
        fetchRequest.fetchLimit = 1

        do {
            return try context.count(for: fetchRequest) > 0
        } catch {
            return false
        }
    }

    func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            context.rollback()
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
