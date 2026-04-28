import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Leegoo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle error
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    } ()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Favorite Management
    
    func saveLeague(league: League) {
        // Check if already exists
        if isLeagueFavorite(id: league.idLeague ?? "") { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteLeague", in: context)!
        let favorite = NSManagedObject(entity: entity, insertInto: context)
        
        favorite.setValue(league.idLeague, forKey: "idLeague")
        favorite.setValue(league.strLeague, forKey: "strLeague")
        favorite.setValue(league.strBadge, forKey: "strBadge")
        favorite.setValue(league.strYoutube, forKey: "strYoutube")
        favorite.setValue(league.strSport, forKey: "strSport")
        
        saveContext()
    }
    
    func fetchFavorites() -> [League] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeague")
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { favorite in
                League(
                    idLeague: favorite.value(forKey: "idLeague") as? String,
                    strLeague: favorite.value(forKey: "strLeague") as? String,
                    strBadge: favorite.value(forKey: "strBadge") as? String,
                    strYoutube: favorite.value(forKey: "strYoutube") as? String,
                    strSport: favorite.value(forKey: "strSport") as? String
                )
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func deleteLeague(id: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeague")
        fetchRequest.predicate = NSPredicate(format: "idLeague == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func isLeagueFavorite(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeague")
        fetchRequest.predicate = NSPredicate(format: "idLeague == %@", id)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
