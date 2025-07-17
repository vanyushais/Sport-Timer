//
//  HistoryView.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Поиск
                TextField("Поиск...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.applySearchFilter()
                    }

                // Список тренировок
                List {
                    if viewModel.filteredWorkouts.isEmpty {
                        Text("Нет тренировок")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.filteredWorkouts, id: \.id) { workout in
                            WorkoutRow(workout: workout)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteWorkout(workout)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchWorkouts()
                    viewModel.applySearchFilter()
                }
                .listStyle(.plain)
            }
            .navigationTitle("История")
        }
    }
}


#Preview {
    HistoryView()
}
