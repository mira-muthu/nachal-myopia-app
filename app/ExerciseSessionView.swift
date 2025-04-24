import SwiftUI
import AVFoundation

struct ExerciseSessionView: View {
    let exercise: EyeExercise
    @State private var timeLeft: Int
    @Environment(\.dismiss) var dismiss
    @State private var timer: Timer?
    @State private var isStarted = false
    @State private var backgroundColor: Color = .white
    @State private var audioPlayer: AVAudioPlayer?

    init(exercise: EyeExercise) {
        self.exercise = exercise
        self._timeLeft = State(initialValue: exercise.duration)
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.0), value: backgroundColor)

            VStack(spacing: isStarted ? 20 : 30) {
                if isStarted { Spacer() }

                if !exercise.gifName.isEmpty {
                    GIFView(gifName: exercise.gifName)
                        .frame(width: isStarted ? 300 : 180, height: isStarted ? 300 : 180)
                        .scaleEffect(isStarted ? 1.4 : 1.0) // more zoom
                        .transition(.scale)
                        .animation(.easeInOut(duration: 0.5), value: isStarted)
                } else {
                    Text("👁️")
                        .font(.system(size: isStarted ? 100 : 60))
                        .scaleEffect(isStarted ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: isStarted)
                }

                if !isStarted {
                    Text(exercise.name)
                        .font(.largeTitle)
                        .bold()

                    Text(exercise.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                if isStarted {
                    Text("⏱️ \(timeLeft)s")
                        .font(.title)
                        .bold()
                        .transition(.scale)
                        .animation(.easeInOut, value: timeLeft)
                }

                if !isStarted {
                    Button("Start") {
                        withAnimation {
                            isStarted = true
                            backgroundColor = Color.blue.opacity(0.15)
                            startTimer()
                            playChime()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                if timeLeft == 0 && isStarted {
                    Text("✅ Done! Returning to timer...")
                        .foregroundColor(.green)
                        .bold()
                        .transition(.opacity)
                }

                if isStarted { Spacer() }
            }
            .padding()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func startTimer() {
        timer?.invalidate()
        timeLeft = exercise.duration

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                timer?.invalidate()
                playChime()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
    }

    func playChime() {
        guard let soundURL = Bundle.main.url(forResource: "chime", withExtension: "wav") else {
            print("Chime sound not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
