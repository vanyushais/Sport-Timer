//
//  ProfileView.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var isBouncing = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Аватар
                    if let image = viewModel.avatarImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .onTapGesture {
                                showingImagePicker = true
                            }
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                showingImagePicker = true
                            }
                    }

                    Text("Твоё здоровье — в твоих руках 💪")
                        .font(.headline)

                    // Статистика
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Тренировок:")
                            Spacer()
                            Text("\(viewModel.workoutCount)")
                        }

                        HStack {
                            Text("Общее время:")
                            Spacer()
                            Text(formatDuration(viewModel.totalDuration))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Настройка звука
                    Toggle(isOn: $viewModel.soundEnabled) {
                        Text("Воспроизводить звуки")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Очистка данных
                    Button(role: .destructive) {
                        viewModel.clearAllData()
                    } label: {
                        Text("Очистить все данные")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.warning)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    .buttonStyle(BounceDestructiveStyle())

                    // Информация
                    VStack(spacing: 4) {
                        Text("Версия приложения: 1.0")
                        Text("Разработано с ❤️ на SwiftUI")
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 32)
                }
                .padding()
            }
            .navigationTitle("Профиль")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    private func loadImage() {
        guard let selected = inputImage else { return }
        viewModel.saveAvatar(selected)
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
    ProfileView()
}
