import SwiftUI
import UserNotifications
import AVFoundation

struct AppLockView: View {
    @State private var focusDuration = 30
    @State private var breakDuration = 5
    @State private var timeLeft = 0
    @State private var isFocusMode = true
    @State private var timer: Timer?
    @State private var showInstructions = false
    @State private var backgroundColor: Color = .white
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack(spacing: 30) {
            Text("📵 App Lock Mode")
                .font(.largeTitle)
                .bold()

            Text("Reduce screen time to protect your eyes from myopia.")
                .font(.body)
                .multilineTextAlignment(.center)

            Stepper("Focus Duration: \(focusDuration) min", value: $focusDuration, in: 10...90, step: 5)
            Stepper("Break Duration: \(breakDuration) min", value: $breakDuration, in: 1...30, step: 1)

            if timeLeft > 0 {
                Text("\(isFocusMode ? "Focus Time" : "Break Time") Remaining: \(formatTime(timeLeft))")
                    .font(.title2)
                    .foregroundColor(.gray)
            }

            HStack(spacing: 20) {
                Button("Start Lock") {
                    startFocus()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Stop") {
                    stopTimer()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Button("❓ How to Lock Other Apps") {
                showInstructions = true
            }
            .font(.footnote)
        }
        .padding()
        .sheet(isPresented: $showInstructions) {
            GuidedAccessInstructionsView()
        }
        .background(backgroundColor.ignoresSafeArea())
        .onDisappear {
            stopTimer()
        }
    }

    func startFocus() {
        isFocusMode = true
        timeLeft = focusDuration * 60
        startTimer()
        backgroundColor = Color.white
    }

    func startBreak() {
        isFocusMode = false
        timeLeft = breakDuration * 60
        backgroundColor = Color.blue.opacity(0.15)
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeLeft -= 1
            if timeLeft <= 0 {
                timer?.invalidate()
                playChime()
                if isFocusMode {
                    startBreak()
                } else {
                    startFocus()
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timeLeft = 0
    }

    func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    func playChime() {
        guard let url = Bundle.main.url(forResource: "chime", withExtension: "wav") else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
}
