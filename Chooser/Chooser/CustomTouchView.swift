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
    var didReachMaxTouches: (() -> Void)? // <--- callback, чтобы показать новую вью

    struct TouchInfo {
        let layer: CALayer
        let playerNumber: Int
    }

    private var touchLayers: [ObjectIdentifier: TouchInfo] = [:]

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
            if let maxPlayer = settings?.numberOfPlayers, touchesCount >= maxPlayer {
                return
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
            textLayer.string = "\(touchesCount)"
            textLayer.alignmentMode = .center
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.fontSize = 40
            textLayer.frame = backgroundLayer.bounds
            textLayer.contentsScale = UIScreen.main.scale

            backgroundLayer.addSublayer(textLayer)

            touchLayers[id] = TouchInfo(layer: backgroundLayer, playerNumber: touchesCount)

            // Если достигли максимального количества касаний
            if let maxPlayer = settings?.numberOfPlayers, touchesCount == maxPlayer {
                didReachMaxTouches?() // вызываем callback
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let id = ObjectIdentifier(touch)
            guard let layer = touchLayers[id]?.layer else { continue }
            
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
        guard let maxPlayer = settings?.numberOfPlayers, touchesCount != maxPlayer else { return }
        removeLayers(for: touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeLayers(for: touches)
    }

    private func removeLayers(for touches: Set<UITouch>) {
        for touch in touches {
            touchesCount -= 1
            let id = ObjectIdentifier(touch)
            touchLayers[id]?.layer.removeFromSuperlayer()
            touchLayers.removeValue(forKey: id)
        }
    }
    
    func pickRandomTouchLayer() -> (id: ObjectIdentifier, info: TouchInfo)? {
        guard !touchLayers.isEmpty else { return nil }
        
        let keys = Array(touchLayers.keys)
        if let randomKey = keys.randomElement(), let info = touchLayers[randomKey] {
            return (id: randomKey, info: info)
        }
        return nil
    }

    func removeTouchLayer(for id: ObjectIdentifier) {
        if let layer = touchLayers[id]?.layer {
            layer.removeFromSuperlayer()
            touchLayers.removeValue(forKey: id)
        }
    }
    
    func remainingTouchInfos() -> [TouchInfo] {
        return touchLayers.map { $0.value }
    }
    
    func reset() {
        for (_, info) in touchLayers {
            info.layer.removeFromSuperlayer()
        }
        touchLayers.removeAll()
        touchesCount = 0
    }

}
