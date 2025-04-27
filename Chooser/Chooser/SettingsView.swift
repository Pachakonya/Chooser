//
//  SettingsView.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 27.04.2025.
//
import SwiftUI

struct SettingsView: View {
    @State private var selectedPlayers = 2
    @State private var addTasks = false
    @State private var losingPlayerLeaves = true
    @State private var selectedLevel = "Super Easy"
    @State private var selectedTime = 1

    @State private var settings: GameSettings? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Fixed Header
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)

                ScrollView {
                    VStack(spacing: 20) {
                        RadioButtonSection(title: "Players", options: [2, 3], selection: $selectedPlayers) { value in
                            Text("\(value) players")
                        }
                        RadioButtonSection(title: "Do you mind adding tasks?", options: [false, true], selection: $addTasks) { value in
                            Text(value ? "Yes, add" : "No, thanks")
                        }
                        ToggleSection(title: "Losing player leaves", isOn: $losingPlayerLeaves)
                        RadioButtonSection(title: "Level", options: ["Super Easy", "Easy"], selection: $selectedLevel) { value in
                            Text(value)
                        }
                        RadioButtonSection(title: "Time to complete", options: [1, 5], selection: $selectedTime) { value in
                            Text("\(value) min")
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
                Button(action: {
                    // Формируем модель
                    settings = GameSettings(
                        numberOfPlayers: selectedPlayers,
                        addTasks: addTasks,
                        losingPlayerLeaves: losingPlayerLeaves,
                        level: selectedLevel,
                        timeToComplete: selectedTime
                    )
                }) {
                    Text("Alga, kettik!")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(Color.white)
                .navigationDestination(item: $settings) { settings in
                    CountdownView(settings: settings)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Модель настроек

struct GameSettings: Identifiable, Hashable {
    let id = UUID()
    let numberOfPlayers: Int
    let addTasks: Bool
    let losingPlayerLeaves: Bool
    let level: String
    let timeToComplete: Int
}

struct GameView: View {
    let settings: GameSettings

    var body: some View {
        VStack(spacing: 20) {
            Text("Game Started!")
                .font(.largeTitle)
                .bold()

            Text("Players: \(settings.numberOfPlayers)")
            Text("Add Tasks: \(settings.addTasks ? "Yes" : "No")")
            Text("Losing player leaves: \(settings.losingPlayerLeaves ? "Yes" : "No")")
            Text("Level: \(settings.level)")
            Text("Time: \(settings.timeToComplete) min")

            Spacer()
        }
        .padding()
    }
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
