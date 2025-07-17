//
//  TimerView.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // Круг с таймером
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.2)
                    .foregroundColor(.blue)

                Circle()
                    .trim(from: 0.0, to: viewModel.progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: -90))

                Text(viewModel.timeFormatted)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
            }
            .frame(width: 200, height: 200)
            .animation(.easeInOut, value: viewModel.progress)

            // Picker для типа тренировки
            Picker("Тип тренировки", selection: $viewModel.selectedType) {
                ForEach(viewModel.types, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)

            // Поле для заметок
            TextField("Заметки (необязательно)", text: $viewModel.notes)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            // Кнопки
            HStack(spacing: 20) {
                Button(viewModel.isRunning ? "Пауза" : "Старт") {
                    viewModel.toggleTimer()
                }
                .buttonStyle(MainButtonStyle(color: viewModel.isRunning ? AppColors.primary : AppColors.success))

                Button("Стоп") {
                    viewModel.stopTimer()
                }
                .buttonStyle(MainButtonStyle(color: AppColors.danger))
                .disabled(!viewModel.hasStarted)
            }
        }
        .padding()
        .navigationTitle("Таймер")
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.resumeAfterBackground()
        }
        .onAppear {
            viewModel.requestNotificationPermission()
        }
    }
}


#Preview {
    TimerView()
}
