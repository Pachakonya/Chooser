//
//  CustomTouchView.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 27.04.2025.
//
import SwiftUI
import UIKit

class CustomTouchView: UIView {
    var settings: GameSettings?
    var touchesCount = 0
    var maxTouches = 3 // <--- добавляем лимит касаний
    var didReachMaxTouches: (() -> Void)? // <--- callback, чтобы показать новую вью

    private var touchLayers: [ObjectIdentifier: CALayer] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        backgroundColor = UIColor(red: 114/255, green: 133/255, blue: 226/255, alpha: 1.0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isMultipleTouchEnabled = true
        backgroundColor = UIColor(red: 114/255, green: 133/255, blue: 226/255, alpha: 1.0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // Проверяем, можно ли ещё добавлять касания
            if touchesCount >= maxTouches {
                return // больше не обрабатываем касания
            }
            
            touchesCount += 1
            
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackGenerator.impactOccurred()
            
            let id = ObjectIdentifier(touch)

            let backgroundLayer = CALayer()
            backgroundLayer.bounds = CGRect(x: 0, y: 0, width: 160, height: 160)
            backgroundLayer.cornerRadius = 80
            backgroundLayer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
            backgroundLayer.position = touch.location(in: self)
            self.layer.addSublayer(backgroundLayer)

            let textLayer = CATextLayer()
            textLayer.string = "\(touchesCount)"  // показываем текущий номер касания
            textLayer.alignmentMode = .center
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.fontSize = 40
            textLayer.frame = backgroundLayer.bounds
            textLayer.contentsScale = UIScreen.main.scale

            backgroundLayer.addSublayer(textLayer)

            touchLayers[id] = backgroundLayer

            // Если достигли максимального количества касаний
            if touchesCount == maxTouches {
                didReachMaxTouches?() // вызываем callback
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            guard let layer = touchLayers[id] else { continue }
            
            let newPosition = touch.location(in: self)
            
            if layer.position != newPosition {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.position = newPosition
                CATransaction.commit()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeLayers(for: touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeLayers(for: touches)
    }

    private func removeLayers(for touches: Set<UITouch>) {
        for touch in touches {
            touchesCount -= 1
            let id = ObjectIdentifier(touch)
            touchLayers[id]?.removeFromSuperlayer()
            touchLayers.removeValue(forKey: id)
        }
    }
    
    func pickRandomTouchLayer() -> (id: ObjectIdentifier, layer: CALayer, playerNumber: Int)? {
        guard !touchLayers.isEmpty else { return nil }
        
        let keys = Array(touchLayers.keys)
        if let randomKey = keys.randomElement(), let layer = touchLayers[randomKey] {
            let index = keys.firstIndex(of: randomKey) ?? 0
            return (id: randomKey, layer: layer, playerNumber: index + 1)
        }
        return nil
    }

    func removeTouchLayer(for id: ObjectIdentifier) {
        if let layer = touchLayers[id] {
            layer.removeFromSuperlayer()
            touchLayers.removeValue(forKey: id)
        }
    }

}
