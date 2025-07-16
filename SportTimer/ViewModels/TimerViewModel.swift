//
//  TimerViewModel.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import Foundation
import Combine
import SwiftUI
import UserNotifications

class TimerViewModel: ObservableObject {
    // MARK: - Published
    @Published var secondsElapsed: Int = 0
    @Published var isRunning = false
    @Published var hasStarted = false
    @Published var notes: String = ""
    @Published var selectedType: String = "Strength"

    // MARK: - Workout types
    let types = ["Strength", "Cardio", "Yoga", "Stretching", "Other"]

    private var timer: Timer?
    private var startDate: Date?

    // MARK: - Computed
    var timeFormatted: String {
        let hrs = secondsElapsed / 3600
        let mins = (secondsElapsed % 3600) / 60
        let secs = secondsElapsed % 60

        if hrs > 0 {
            return String(format: "%02d:%02d:%02d", hrs, mins, secs)
        } else {
            return String(format: "%02d:%02d", mins, secs)
        }
    }

    var progress: CGFloat {
        CGFloat(secondsElapsed % 60) / 60.0
    }

    // MARK: - Methods
    func toggleTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }

    func startTimer() {
        hasStarted = true
        isRunning = true
        startDate = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        hasStarted = false

        updateElapsedTime()
        saveWorkout()
        sendWorkoutCompletedNotification()

        secondsElapsed = 0
        notes = ""
        startDate = nil
    }

    private func updateElapsedTime() {
        guard let start = startDate else { return }
        secondsElapsed = Int(Date().timeIntervalSince(start))
    }

    func resumeAfterBackground() {
        guard isRunning else { return }
        updateElapsedTime()
    }
    
    

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Ошибка запроса разрешения: \(error)")
            }
            print("Разрешение на уведомления: \(granted)")
        }
    }

    
    private func sendWorkoutCompletedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Тренировка завершена!"
        content.body = "Ты молодец! Отдохни и не забывай пить воду 💧"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // мгновенно
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка отправки уведомления: \(error)")
            }
        }
    }


    private func saveWorkout() {
        let context = PersistenceController.shared.container.viewContext
        let workout = Workout(context: context)
        workout.id = UUID()
        workout.date = Date()
        workout.duration = Int32(secondsElapsed)
        workout.type = selectedType
        workout.notes = notes

        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении тренировки: \(error)")
        }
    }
}


//import Foundation
//import Combine
//
//class TimerViewModel: ObservableObject {
//    // MARK: - Published
//    @Published var secondsElapsed: Int = 0
//    @Published var isRunning = false
//    @Published var hasStarted = false
//    @Published var notes: String = ""
//    @Published var selectedType: String = "Strength"
//
//    // MARK: - Workout types
//    let types = ["Strength", "Cardio", "Yoga", "Stretching", "Other"]
//
//    private var timer: Timer?
//    private var startDate: Date?
//
//    // MARK: - Computed
//    var timeFormatted: String {
//        let hrs = secondsElapsed / 3600
//        let mins = (secondsElapsed % 3600) / 60
//        let secs = secondsElapsed % 60
//
//        if hrs > 0 {
//            return String(format: "%02d:%02d:%02d", hrs, mins, secs)
//        } else {
//            return String(format: "%02d:%02d", mins, secs)
//        }
//    }
//
//    var progress: CGFloat {
//        CGFloat(secondsElapsed % 60) / 60.0
//    }
//
//    // MARK: - Methods
//    func toggleTimer() {
//        if isRunning {
//            pauseTimer()
//        } else {
//            startTimer()
//        }
//    }
//
//    func startTimer() {
//        hasStarted = true
//        isRunning = true
//        startDate = Date()
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.secondsElapsed += 1
//        }
//    }
//
//    func pauseTimer() {
//        isRunning = false
//        timer?.invalidate()
//    }
//
//    func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//        isRunning = false
//        hasStarted = false
//
//        saveWorkout()
//        secondsElapsed = 0
//        notes = ""
//    }
//
//    private func saveWorkout() {
//        let context = PersistenceController.shared.container.viewContext
//        let workout = Workout(context: context)
//        workout.id = UUID()
//        workout.date = Date()
//        workout.duration = Int32(secondsElapsed)
//        workout.type = selectedType
//        workout.notes = notes
//
//        do {
//            try context.save()
//        } catch {
//            print("Ошибка при сохранении тренировки: \(error)")
//        }
//    }
//
//}

