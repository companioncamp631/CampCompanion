// SoundManager.swift
import Foundation
import AVFoundation

// SoundManager теперь ObservableObject, чтобы View мог отслеживать его состояние.
// Он также наследуется от NSObject и реализует AVAudioPlayerDelegate,
// чтобы отслеживать окончание воспроизведения звука.
class SoundManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    // @Published свойство. Любые изменения этого свойства будут автоматически
    // отправляться всем подписчикам (нашему View).
    @Published var isPlaying: Bool = false
    
    // Приватный init, чтобы никто не мог создать второй экземпляр, кроме нашего синглтона
    private override init() {
        super.init()
    }

    /// Переключает состояние воспроизведения звука (вкл/выкл).
    /// - Parameters:
    ///   - soundName: Имя файла без расширения.
    ///   - loop: Нужно ли зацикливать звук. Для SOS это полезно.
    func toggleSound(soundName: String, fileExtension: String = "mp3", loop: Bool = true) {
        if isPlaying {
            // Если звук уже играет, останавливаем его.
            stop()
        } else {
            // Если звук не играет, запускаем его.
            play(soundName: soundName, fileExtension: fileExtension, loop: loop)
        }
    }
    
    private func play(soundName: String, fileExtension: String, loop: Bool) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: fileExtension) else {
            print("Ошибка: Не удалось найти звуковой файл \(soundName).\(fileExtension)")
            return
        }
        
        do {
            // Настраиваем аудиосессию, чтобы звук играл даже в беззвучном режиме
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self // Устанавливаем себя делегатом
            
            if loop {
                audioPlayer?.numberOfLoops = -1 // -1 означает бесконечное зацикливание
            }
            
            audioPlayer?.play()
            isPlaying = true // Обновляем состояние
            
        } catch let error {
            print("Ошибка воспроизведения звука: \(error.localizedDescription)")
            isPlaying = false
        }
    }
    
    private func stop() {
        audioPlayer?.stop()
        isPlaying = false // Обновляем состояние
    }
    
    // Этот метод делегата будет вызван автоматически, когда звук закончится (если он не зациклен)
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
