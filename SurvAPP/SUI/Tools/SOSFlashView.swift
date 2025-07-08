//
//  SOSFlashView.swift
//  SurvAPP
//
//  Created by D K on 08.07.2025.
//


import Foundation
import AVFoundation

// Определяем единицу сигнала: длительность и пауза после него
fileprivate enum SignalPulse {
    case dot
    case dash

    var duration: TimeInterval {
        switch self {
        case .dot: return 0.2 // Длительность точки
        case .dash: return 0.6 // Длительность тире
        }
    }
}

@MainActor // Гарантирует, что изменения @Published будут происходить на главном потоке
class FlashlightManager: ObservableObject {
    
    // Свойство для отслеживания состояния (запущен SOS или нет)
    @Published var isSOSSending = false
    
    // SOS последовательность: 3 точки, 3 тире, 3 точки
    private let sosSequence: [SignalPulse] = [
        .dot, .dot, .dot,   // S
        .dash, .dash, .dash, // O
        .dot, .dot, .dot    // S
    ]
    
    // Определяем длительность пауз
    private let pauseIntraLetter: TimeInterval = 0.2 // Пауза между сигналами внутри буквы
    private let pauseInterLetter: TimeInterval = 0.8 // Пауза между буквами (S и O)
    private let pauseEndSequence: TimeInterval = 2.0 // Пауза после полного "SOS"
    
    /// Включает или выключает фонарик
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("Устройство не имеет фонарика")
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            if on {
                // Устанавливаем яркость, чтобы не перегревать устройство
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            device.unlockForConfiguration()
        } catch {
            print("Ошибка при управлении фонариком: \(error)")
        }
    }
    
    /// Запускает или останавливает последовательность SOS
    func triggerSOS() async {
        if isSOSSending {
            // Если уже запущен, то это команда на остановку
            // Состояние изменится само при завершении или отмене задачи
            return
        }
        
        isSOSSending = true
        
        // Гарантируем, что фонарик выключится при выходе из функции
        // (нормальном, из-за ошибки или отмены)
        defer {
            toggleTorch(on: false)
            isSOSSending = false
            print("SOS последовательность завершена.")
        }
        
        // Бесконечный цикл, который можно прервать извне (отменой задачи)
        while !Task.isCancelled {
            // Проходим по всей последовательности S-O-S
            for (index, pulse) in sosSequence.enumerated() {
                // Проверяем на отмену перед каждым сигналом
                if Task.isCancelled { break }
                
                // Включаем фонарик
                toggleTorch(on: true)
                // Ждем нужную длительность (точка или тире)
                try? await Task.sleep(for: .seconds(pulse.duration))
                
                // Выключаем фонарик
                toggleTorch(on: false)
                
                // Выбираем правильную паузу после сигнала
                let pause = getPauseDuration(for: index)
                try? await Task.sleep(for: .seconds(pause))
            }
            
            // Если задача была отменена во время цикла, выходим
            if Task.isCancelled { break }
            
            // Длинная пауза после полного слова "SOS"
            try? await Task.sleep(for: .seconds(pauseEndSequence))
        }
    }
    
    /// Определяет, какую паузу использовать после текущего сигнала
    private func getPauseDuration(for index: Int) -> TimeInterval {
        // Индексы, после которых заканчивается буква (S, O)
        let letterEndIndices = [2, 5]
        
        if letterEndIndices.contains(index) {
            return pauseInterLetter // Пауза между буквами
        } else {
            return pauseIntraLetter // Пауза внутри буквы
        }
    }
}

// SOSFlashlightView.swift
import SwiftUI

struct SOSFlashlightView: View {
    
    // Создаем экземпляр нашего менеджера
    // @StateObject гарантирует, что он будет жить пока View на экране
    @StateObject private var flashlightManager = FlashlightManager()
    @Environment(\.dismiss) var dismiss

    
    // Свойство для хранения запущенной задачи, чтобы мы могли ее отменить
    @State private var sosTask: Task<Void, Never>?
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Иконка для наглядности
                Image(systemName: flashlightManager.isSOSSending ? "sos.circle.fill" : "sos.circle")
                    .font(.system(size: 100))
                    .foregroundColor(flashlightManager.isSOSSending ? .red : Color.accentYellow)
                
                // Текст состояния
                if flashlightManager.isSOSSending {
                    Text("Transmitting SOS signal...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                } else {
                    Text("Ready to transmit signal")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                }
                
                // Основная кнопка
                Button(action: {
                    // Проверяем, есть ли активная задача
                    if let task = sosTask {
                        // Если есть, отменяем ее
                        task.cancel()
                        sosTask = nil
                    } else {
                        // Если нет, создаем новую
                        sosTask = Task {
                            await flashlightManager.triggerSOS()
                            // Когда задача завершится (или будет отменена),
                            // сбрасываем ее, чтобы кнопка снова стала "Start"
                            sosTask = nil
                        }
                    }
                }) {
                    Text(flashlightManager.isSOSSending ? "Stop SOS" : "Start SOS transmission")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(flashlightManager.isSOSSending ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                
            }
            .animation(.easeInOut, value: flashlightManager.isSOSSending)
            .onDisappear {
                // Если пользователь уходит с экрана, останавливаем SOS
                sosTask?.cancel()
            }
            
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
}

// Для предпросмотра в Xcode
struct SOSFlashlightView_Previews: PreviewProvider {
    static var previews: some View {
        SOSFlashlightView()
    }
}
