// MotionCompassHeading.swift
import Foundation
import CoreMotion
import SwiftUI // Для @MainActor

@MainActor
class MotionCompassHeading: ObservableObject {
    
    @Published var degrees: Double = 0.0
    
    private let motionManager: CMMotionManager
    
    init() {
        self.motionManager = CMMotionManager()
        self.startUpdating()
    }
    
    func startUpdating() {
        // Проверяем, доступна ли нужная функциональность
        if motionManager.isDeviceMotionAvailable {
            // Устанавливаем частоту обновлений
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 раз в секунду
            
            // Начинаем получать обновления. Это самый важный шаг.
            // .xMagneticNorthZVertical — это система отсчета, где ось X указывает на магнитный север,
            // а ось Z — вертикальна.
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main) { [weak self] (motion, error) in
                
                guard let self = self, let motion = motion else { return }
                
                // Угол рыскания (yaw) в этой системе отсчета и будет нашим направлением.
                // Он измеряется в радианах.
                let yaw = motion.attitude.yaw
                
                // Конвертируем радианы в градусы
                var degrees = yaw * 180.0 / .pi
                
                // Нормализуем значение, чтобы оно было в диапазоне 0-360
                if degrees < 0 {
                    degrees += 360.0
                }
                
                self.degrees = degrees
            }
        } else {
            print("Device motion не доступен на этом устройстве.")
        }
    }
    
    deinit {
        // Не забываем останавливать обновления, когда объект уничтожается
        motionManager.stopDeviceMotionUpdates()
    }
}

// MotionCompassView.swift
import SwiftUI

struct MotionCompassView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var compassHeading = MotionCompassHeading()
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                
                Spacer()
                
                Text("Compass")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("\(Int(compassHeading.degrees))° \(cardinalDirection(from: compassHeading.degrees))")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)

                
                ZStack {
                    // Роза ветров (вращающаяся часть)
                    compassRoseView()
                        .rotationEffect(.degrees(-compassHeading.degrees))
                    
                    // Статичная стрелка
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow) // Поменяем цвет, чтобы отличать от другого компаса
                        .background(Circle().fill(.white).scaleEffect(0.6))
                }
                .frame(width: 300, height: 300)
                
                Spacer()
                Spacer()
            }
            .padding()
            
            VStack {
                
                HStack {
                    Button(action: {dismiss()}) {
                        Image("icon_back_arrow") // Убедись, что у тебя есть такая картинка
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 34, height: 34)
                                                    .colorInvert()
                                                    .colorMultiply(.yellow)
                    }
                    
                    Spacer()
                    
                   
                }
             
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    private func cardinalDirection(from degrees: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((degrees + 22.5) / 45.0) & 7
        return directions[index]
    }
    
    @ViewBuilder
    private func compassRoseView() -> some View {
        ZStack {
            Circle().fill(Color(UIColor.systemGray5))
            Circle().stroke(Color.gray, lineWidth: 2)
            Text("N").position(x: 150, y: 30).font(.title.weight(.bold))
            Text("S").position(x: 150, y: 270).font(.title.weight(.bold))
            Text("W").position(x: 270, y: 150).font(.title.weight(.bold))
            Text("E").position(x: 30, y: 150).font(.title.weight(.bold))
            ForEach(0..<36) { i in
                let angle = Double(i) * 10.0
                let isMajorTick = i % 3 == 0
                Rectangle()
                    .fill(isMajorTick ? Color.black : Color.gray)
                    .frame(width: 2, height: isMajorTick ? 20 : 10)
                    .offset(y: -135)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
}

struct MotionCompassView_Previews: PreviewProvider {
    static var previews: some View {
        MotionCompassView()
    }
}
