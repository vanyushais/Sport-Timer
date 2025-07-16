//
//  ProfileViewModel.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import SwiftUI
import CoreData
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var totalDuration: Int = 0
    @Published var workoutCount: Int = 0
    @Published var avatarImage: UIImage?

    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchStatistics()
        loadAvatar()
    }

    func fetchStatistics() {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            let workouts = try context.fetch(request)
            workoutCount = workouts.count
            totalDuration = workouts.reduce(0) { $0 + Int($1.duration) }
        } catch {
            print("Ошибка при загрузке статистики профиля: \(error)")
        }
    }

    func clearAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            try context.save()
            fetchStatistics()
        } catch {
            print("Ошибка при удалении данных: \(error)")
        }
    }

    func saveAvatar(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "avatarImage")
            avatarImage = image
        }
    }

    private func loadAvatar() {
        if let data = UserDefaults.standard.data(forKey: "avatarImage"),
           let image = UIImage(data: data) {
            avatarImage = image
        }
    }
}
