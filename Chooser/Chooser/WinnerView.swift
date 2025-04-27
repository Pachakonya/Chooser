//
//  WinnerView.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 27.04.2025.
//

import SwiftUI

struct WinnerView: View {
    let winnerNumber: Int
    let onRestart: () -> Void

    @State private var animate = false

    var body: some View {
        ZStack {
            Color(red: 114/255, green: 133/255, blue: 226/255)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()
                
                Text("🏆 Player number \(winnerNumber) wins! 🏆")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .cornerRadius(20)
                    .scaleEffect(animate ? 1 : 0.8)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.6), value: animate)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: {
                    onRestart()
                }) {
                    Text("Play Again")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                        .padding()
                        .frame(width: 200)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                
                Spacer()
            }
        }
        .onAppear {
            animate = true
        }
    }
}
