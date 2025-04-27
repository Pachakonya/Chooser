//
//  MultiTouchView.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 27.04.2025.
//
import SwiftUI

struct MultiTouchView: UIViewRepresentable {
    @Binding var isCompleted: Bool
    var settings: GameSettings?
    var viewRef: Binding<CustomTouchView?>
    
    func makeUIView(context: Context) -> CustomTouchView {
        let view = CustomTouchView()
        view.settings = settings
        
        // Сохраняем ссылку
        DispatchQueue.main.async {
            self.viewRef.wrappedValue = view
        }
        
        view.didReachMaxTouches = {
            DispatchQueue.main.async {
                isCompleted = true
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: CustomTouchView, context: Context) {
        uiView.settings = settings
    }
}
