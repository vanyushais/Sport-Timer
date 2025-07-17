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
import AVFoundation

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
    private var pausedTime: Int = 0
    private var audioPlayer: AVAudioPlayer?

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
            isRunning ? pauseTimer() : startTimer()
        }
    
    private func playSound(named soundName: String) {
        let soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        guard soundEnabled else { return }

        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Файл \(soundName).mp3 не найден")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Ошибка при воспроизведении звука: \(error)")
        }
    }



    func startTimer() {
        if !hasStarted {
            hasStarted = true
            startDate = Date()
            secondsElapsed = 0
            pausedTime = 0
        } else {
            // Продолжение после паузы
            startDate = Date().addingTimeInterval(TimeInterval(-pausedTime))
        }
        
        isRunning = true
        playSound(named: "start")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard let start = self.startDate else { return }
            self.secondsElapsed = Int(Date().timeIntervalSince(start))
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        pausedTime = secondsElapsed
        playSound(named: "pause")
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        hasStarted = false
        
        updateElapsedTime()
        saveWorkout()
        sendWorkoutCompletedNotification()
        playSound(named: "stop")
        
        secondsElapsed = 0
        pausedTime = 0
        hasStarted = false
        isRunning = false
        startDate = nil
        notes = ""
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
            trigger: nil
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
