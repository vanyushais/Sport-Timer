//
//  HomeViewModel.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import Foundation
import Combine
import CoreData

class HomeViewModel: ObservableObject {
    @Published var totalDuration: Int = 0
    @Published var workoutCount: Int = 0
    @Published var recentWorkouts: [Workout] = []

    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchStatistics()
        fetchRecentWorkouts()
    }

    func fetchStatistics() {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            let workouts = try context.fetch(request)
            workoutCount = workouts.count
            totalDuration = workouts.reduce(0) { $0 + Int($1.duration) }
        } catch {
            print("Ошибка при загрузке статистики: \(error)")
        }
    }

    func fetchRecentWorkouts() {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Workout.date, ascending: false)]
        request.fetchLimit = 3
        do {
            recentWorkouts = try context.fetch(request)
        } catch {
            print("Ошибка при загрузке последних тренировок: \(error)")
        }
    }
}
