//
//  SettingsView.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 27.04.2025.
//

import SwiftUI
import FirebaseFirestore

struct SettingsView: View {
    @State private var lastWinner: Int? = nil
    @State private var selectedPlayers = 2
    @State private var addTasks = false
    @State private var losingPlayerLeaves = true
    @State private var selectedTime = 10
    @State private var isLoading = false
    @State private var settings: GameSettings? = nil
    @State private var isLastWinnerLoading: Bool = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                
                if isLastWinnerLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                        .frame(maxWidth: .infinity)
                } else {
                    // Отображаем победителя, если он найден
                    if let lastWinner = lastWinner {
                        Text("Last winner: Player number \(lastWinner)")
                            .font(.title2)
                            .padding()
                            .background(Color.green.opacity(0.9))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    } else {
                        Text("No winner found")
                            .font(.title2)
                            .foregroundColor(.red)
                            .padding()
                    }
                }

                ScrollView {
                    VStack(spacing: 20) {
                        RadioButtonSection(title: ConstantValues.players, options: ConstantValues.playersCount, selection: $selectedPlayers) { value in
                            Text("\(value) players")
                        }
                        RadioButtonSection(title: ConstantValues.tasksQuestion, options: ConstantValues.taskOptions, selection: $addTasks) { value in
                            Text(value ? "Yes, add" : "No, thanks")
                        }
                        ToggleSection(title: ConstantValues.losingPlayerLeaves, isOn: $losingPlayerLeaves)
                        RadioButtonSection(title: ConstantValues.timeToComplete, options: ConstantValues.timesToComplete, selection: $selectedTime) { value in
                            Text("\(value) sec")
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
                Button(action: {
                    if addTasks {
                        fetchTasksFromDb()
                    } else {
                        settings = GameSettings(
                            numberOfPlayers: selectedPlayers,
                            addTasks: addTasks,
                            losingPlayerLeaves: losingPlayerLeaves,
                            timeToComplete: selectedTime,
                            tasks: nil
                        )
                    }
                    
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(16)
                            .padding(.horizontal)
                    } else {
                        Text("Alga, kettik!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(16)
                            .padding(.horizontal)
                    }
                }
                .disabled(isLoading)
                .padding(.vertical, 10)
                .background(Color.white)
                .navigationDestination(item: $settings) { settings in
                    if settings.addTasks {
                        TasksModeView(settings: settings)
                    } else {
                        SimpleModeView(settings: settings)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .onAppear {
                fetchLastWinner()
            }
        }
    }
    
    private func fetchTasksFromDb() {
        isLoading = true
        
        FirebaseManager.shared.getTasks { tasks in
            isLoading = false
            
            settings = GameSettings(
                numberOfPlayers: selectedPlayers,
                addTasks: addTasks,
                losingPlayerLeaves: losingPlayerLeaves,
                timeToComplete: selectedTime,
                tasks: tasks
            )
        }
    }
    
    private func fetchLastWinner() {
        FirebaseManager.shared.getWinner { result in
            DispatchQueue.main.async {
                self.isLastWinnerLoading = false
            }

            switch result {
            case .success(let winner):
                DispatchQueue.main.async {
                    self.lastWinner = winner
                }
            case .failed:
                DispatchQueue.main.async {
                    self.lastWinner = nil
                }
            }
        }
    }

}

// MARK: - Модель настроек

struct GameSettings: Identifiable, Hashable {
    let id = UUID()
    let numberOfPlayers: Int
    let addTasks: Bool
    let losingPlayerLeaves: Bool
    let timeToComplete: Int
    let tasks: [String]?
}

struct RadioButtonSection<Option: Hashable, Content: View>: View {
    let title: String
    let options: [Option]
    @Binding var selection: Option
    let label: (Option) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    HStack {
                        Image(systemName: selection == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selection == option ? .blue : .gray)
                        label(option)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ToggleSection: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
