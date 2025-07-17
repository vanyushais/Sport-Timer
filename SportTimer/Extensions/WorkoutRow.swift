//
//  WorkoutRow.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import SwiftUI

struct WorkoutRow: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(workout.type!)
                    .font(.headline)
                Spacer()
                Text(formatDate(workout.date!))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text("Длительность: \(formatDuration(Int(workout.duration)))")
                .font(.subheadline)

            if let notes = workout.notes, !notes.isEmpty {
                Text(notes)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
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

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

