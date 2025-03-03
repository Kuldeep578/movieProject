//
//  PersistentCoordinator.swift
//  MovieProject
//
//  Created by kuldeep Singh on 03/03/25.
//

import Foundation
import CoreData
// MARK: - Persistence Controller
class PersistenceController {
    static let shared = PersistenceController()
    private let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MoviesData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveMovies(_ movies: [Movie]) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        for movie in movies {
            fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
            
            do {
                let existingMovies = try context.fetch(fetchRequest)
                if existingMovies.isEmpty {
                    let newMovie = MovieEntity(context: context)
                    newMovie.id = Int64(movie.id)
                    newMovie.title = movie.title
                    newMovie.overview = movie.overview
                    newMovie.releaseDate = movie.releaseDate
                    newMovie.posterPath = movie.posterPath
                }
            } catch {
                print("Error checking existing movie: \(error)")
            }
        }
        
        saveContext()
    }
    
    func fetchSavedMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            let savedMovies = try context.fetch(fetchRequest)
            return savedMovies.map { entity in
                Movie(id: Int(entity.id),
                      title: entity.title ?? "",
                      overview: entity.overview ?? "",
                      releaseDate: entity.releaseDate,
                      posterPath: entity.posterPath)
            }
        } catch {
            print("Error fetching movies: \(error)")
            return []
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    func saveFavorites(_ favorites: Set<Int>) {
        UserDefaults.standard.set(Array(favorites), forKey: "favoriteMovies")
    }
    
    func loadFavorites() -> Set<Int> {
        let savedFavorites = UserDefaults.standard.array(forKey: "favoriteMovies") as? [Int] ?? []
        return Set(savedFavorites)
    }
}

