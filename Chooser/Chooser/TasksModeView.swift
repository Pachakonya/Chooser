//
//  TasksModeView.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 27.04.2025.
//

import SwiftUI

struct TasksModeView: View {
    @State private var isCompleted = false
    @State private var customTouchView: CustomTouchView? = nil
    @State private var isGameOver = false
    @State private var winnerPlayerNumber: Int? = nil
    @State private var timer: Timer? = nil
    @State private var taskTimer: Timer? = nil
    @State private var countDowmTimerValue = 3
    @State private var taskTimerValue = 10
    @State private var selectedPlayerNumber: Int? = nil
    @State private var selectedTouchId: ObjectIdentifier? = nil
    @State private var currentTask: String? = nil
    @State private var isTaskModeActive = false
    @State private var didPlayerFailTask = false //
    @State private var lastPlayerRemaining = false
    
    let settings: GameSettings
    
    var body: some View {
        ZStack {
            MultiTouchView(isCompleted: $isCompleted, settings: settings, viewRef: $customTouchView)
                .ignoresSafeArea()
            
            VStack {
                Text("Tasks Mode Game")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Text("\(settings.numberOfPlayers) players")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
            }
            if isTaskModeActive {
                VStack(spacing: 30) {
                    // Заголовок с информацией о задании
                    VStack(alignment: .center, spacing: 10) {
                        Text("Player \(selectedPlayerNumber ?? 0), your task:")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(currentTask ?? "Do something!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Время для выполнения задания
                    VStack {
                        Text("Time remaining:")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text("\(taskTimerValue) seconds")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                    }
                    
                    // Кнопка для успешного выполнения задания
                    Button(action: {
                        taskCompleted()
                    }) {
                        Text("I completed the task")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding(.top, 10)
                    }
                    
                    // Кнопка для неуспешного выполнения задания
                    Button(action: {
                        taskFailed()
                    }) {
                        Text("I couldn't complete the task")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding(.top, 10)
                    }
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(25)
                .shadow(radius: 15)
                .transition(.scale)
            } else if isCompleted {
                VStack {
                    VStack {
                        Text("Game starts in:")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding()
                        Text("\(countDowmTimerValue)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(width: 300, height: 150)
                    .background(Color(red: 114/255, green: 133/255, blue: 226/255))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.scale)
                    .animation(.easeInOut, value: isCompleted)
                    
                    Spacer()
                }
                .onAppear {
                    startTimer()
                }
            }
        }
        .fullScreenCover(isPresented: $isGameOver) {
            if let winner = winnerPlayerNumber {
                WinnerView(winnerNumber: winner) {
                    restartGame()
                }
            }
        }
    }
    
    private func restartGame() {
        winnerPlayerNumber = nil
        isCompleted = false
        countDowmTimerValue = 3
        taskTimerValue = settings.timeToComplete
        selectedPlayerNumber = nil
        isGameOver = false
        isTaskModeActive = false
        didPlayerFailTask = false
        lastPlayerRemaining = false
        customTouchView?.reset()
    }
    
    private func startTimer() {
        timer?.invalidate()
        countDowmTimerValue = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if countDowmTimerValue > 1 {
                countDowmTimerValue -= 1
            } else {
                t.invalidate()
                timer = nil

                startTaskMode()
            }
        }
    }
    
    private func startTaskMode() {
        // Включаем режим с заданиями
        guard let result = customTouchView?.pickRandomTouchLayer() else {
            isCompleted = false
            return
        }
        
        selectedPlayerNumber = result.info.playerNumber
        selectedTouchId = result.id
        
        currentTask = ConstantValues.tasks.randomElement()
        isTaskModeActive = true

        // Запускаем таймер на выполнение задания
        startTaskTimer()
    }
    
    private func startTaskTimer() {
        taskTimer?.invalidate()
        taskTimerValue = settings.timeToComplete
        taskTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if taskTimerValue > 0 {
                taskTimerValue -= 1
            } else {
                t.invalidate()
                taskTimer = nil

                taskFailed() // Игрок выбывает, если не успел выполнить задание
            }
        }
    }
    
    private func taskCompleted() {
        isTaskModeActive = false
        didPlayerFailTask = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            startTimer()  // После того как игрок выполнил задание, продолжаем игру
        }
    }

    private func taskFailed() {
        // Игрок не смог выполнить задание, выбывает из игры
        isTaskModeActive = false
        didPlayerFailTask = true
        
        // Удаляем CALayer, так как игрок не выполнил задание
        if let id = selectedTouchId {
            customTouchView?.removeTouchLayer(for: id)
        }
        
        // Проверяем, если остался один игрок
        if let remaining = customTouchView?.remainingTouchInfos(), remaining.count == 1 {
            lastPlayerRemaining = true
            winnerPlayerNumber = remaining.first?.playerNumber
            isGameOver = true
        } else {
            // Игра продолжается
            startTimer()
        }
    }
}
