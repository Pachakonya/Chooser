//
//  CountdownView.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 27.04.2025.
//
//
import SwiftUI

struct CountdownView: View {
    @State private var isCompleted = false
    @State private var timerValue = 10
    @State private var timer: Timer? = nil
    @State private var customTouchView: CustomTouchView? = nil
    
    @State private var selectedPlayerNumber: Int? = nil
    @State private var selectedTouchId: ObjectIdentifier? = nil

    let settings: GameSettings

    var body: some View {
        ZStack {
            MultiTouchView(isCompleted: $isCompleted, settings: settings, viewRef: $customTouchView)
                .ignoresSafeArea()

            if isCompleted {
                VStack {
                    Spacer()

                    VStack {
                        Text("\(timerValue)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(width: 200, height: 200)
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
            
            if let player = selectedPlayerNumber {
                VStack {
                    Text("Player number \(player) loses")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        .transition(.scale)
                }
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timerValue = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if timerValue > 0 {
                timerValue -= 1
            } else {
                t.invalidate()
                timer = nil
                
                if let result = customTouchView?.pickRandomTouchLayer() {
                    selectedPlayerNumber = result.playerNumber
                    selectedTouchId = result.id
                    
                    // После паузы 2 секунды — удаляем
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let id = selectedTouchId {
                            customTouchView?.removeTouchLayer(for: id)
                            selectedPlayerNumber = nil
                            selectedTouchId = nil
                            isCompleted = false
                        }
                    }
                } else {
                    isCompleted = false
                }
            }
        }
    }
}
