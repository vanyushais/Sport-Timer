//
//  HomeView.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 👋 Приветствие и статистика
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Привет!")
                            .font(.largeTitle)
                            .bold()

                        Text("Ты провёл уже \(viewModel.workoutCount) тренировок")
                            .font(.title3)

                        Text("Общее время: \(formatDuration(viewModel.totalDuration))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()

                    // 🚀 Кнопка начала тренировки
                    NavigationLink(destination: TimerView()) {
                        Text("Начать тренировку")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .shadow(radius: 4)
                    }

                    // 🏋️‍♂️ Последние тренировки
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Последние тренировки")
                            .font(.headline)
                            .padding(.horizontal)

                        if viewModel.recentWorkouts.isEmpty {
                            Text("Тренировок пока нет")
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            ForEach(viewModel.recentWorkouts, id: \.id) { workout in
                                WorkoutRow(workout: workout)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Главная")
            .onAppear {
                viewModel.fetchStatistics()
                viewModel.fetchRecentWorkouts()
            }
        }
    }

    private func formatDuration(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60

        if hrs > 0 {
            return String(format: "%02d:%02d:%02d", hrs, mins, secs)
        } else {
            return String(format: "%02d:%02d", mins, secs)
        }
    }
}


#Preview {
    HomeView()
}
