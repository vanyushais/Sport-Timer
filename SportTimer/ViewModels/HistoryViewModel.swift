//
//  HistoryViewModel.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import Foundation
import CoreData

class HistoryViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var searchText: String = ""
    @Published var filteredWorkouts: [Workout] = []

    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchWorkouts()
    }

    func fetchWorkouts() {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Workout.date, ascending: false)]
        do {
            workouts = try context.fetch(request)
            filteredWorkouts = workouts
        } catch {
            print("Ошибка при загрузке тренировок: \(error)")
        }
    }

    func deleteWorkout(_ workout: Workout) {
        context.delete(workout)
        do {
            try context.save()
            fetchWorkouts()
        } catch {
            print("Ошибка при удалении тренировки: \(error)")
        }
    }

    func applySearchFilter() {
        if searchText.isEmpty {
            filteredWorkouts = workouts
        } else {
            let lowercasedQuery = searchText.lowercased()
            filteredWorkouts = workouts.filter {
                $0.type!.lowercased().contains(lowercasedQuery) ||
                ($0.notes?.lowercased().contains(lowercasedQuery) ?? false)
            }
        }
    }
}
