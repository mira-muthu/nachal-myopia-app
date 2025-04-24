import SwiftUI
import UserNotifications

struct EyeExercise: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let duration: Int
    let gifName: String
}

struct EyeExerciseView: View {
    @AppStorage("completedExercises") private var completedExercises = 0

    @State private var selectedIntervalIndex = 0
    @State private var timeUntilNext = 0
    @State private var isTimerRunning = false
    @State private var showExercise = false
    @State private var currentExercise: EyeExercise?
    @State private var loopTimer: Timer?

    let availableIntervals: [(label: String, waitTime: Int, exerciseDuration: Int)] = [
        ("10 sec (Test)", 10, 10),
        ("10 min", 600, 10),
        ("15 min", 900, 15),
        ("20 min", 1200, 20),
        ("25 min", 1500, 25),
        ("30 min", 1800, 30),
        ("35 min", 2100, 35),
        ("40 min", 2400, 40)
    ]

    let exercises: [EyeExercise] = [
        EyeExercise(name: "Palming", description: "Rub hands, cup over eyes gently and breathe deeply.", duration: 60, gifName: "palming"),
        EyeExercise(name: "Blinking", description: "Close eyes gently, pause, then open. Blink consciously.", duration: 10, gifName: "blinking"),
        EyeExercise(name: "Near and Far Focus", description: "Alternate focus from 10 inches to 20 feet every 15 seconds.", duration: 30, gifName: "nearandfarfocus"),
        EyeExercise(name: "Figure Eight", description: "Trace a figure 8 with your eyes on the floor.", duration: 30, gifName: "figure8"),
        EyeExercise(name: "Eye Movements", description: "Move eyes up/down then left/right 3 times.", duration: 20, gifName: "eyemovements"),
        EyeExercise(name: "Focus Workout", description: "Track your finger close and far while focusing.", duration: 20, gifName: "focusworkout1")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("🧘 Eye Break Exercises")
                    .font(.largeTitle)
                    .bold()

                Text("✅ Exercises Completed: \(completedExercises)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Picker("Choose Interval", selection: $selectedIntervalIndex) {
                    ForEach(0..<availableIntervals.count, id: \.self) { index in
                        let interval = availableIntervals[index]
                        Text("\(interval.label) ⟶ \(interval.exerciseDuration) sec")
                            .tag(index)
                    }
                }
                .pickerStyle(.wheel)

                if isTimerRunning {
                    Text("Next exercise in: \(formatTime(timeUntilNext))")
                        .font(.title2)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 20) {
                    Button(action: startLoop) {
                        Label("Start", systemImage: "play.circle.fill")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: stopLoop) {
                        Label("Stop", systemImage: "xmark.circle.fill")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("Eye Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showExercise, onDismiss: restartLoop) {
                if let exercise = currentExercise {
                    ExerciseSessionView(exercise: exercise)
                }
            }
        }
        .onDisappear {
            stopLoop()
        }
    }

    func startLoop() {
        stopLoop()
        let interval = availableIntervals[selectedIntervalIndex].waitTime
        timeUntilNext = interval
        isTimerRunning = true

        loopTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeUntilNext > 0 {
                timeUntilNext -= 1
            } else {
                triggerExercise()
            }
        }
    }

    func restartLoop() {
        startLoop()
    }

    func stopLoop() {
        loopTimer?.invalidate()
        isTimerRunning = false
        timeUntilNext = 0
    }

    func triggerExercise() {
        stopLoop()
        currentExercise = exercises.randomElement()
        showExercise = true
        completedExercises += 1

        if UIApplication.shared.applicationState != .active {
            let content = UNMutableNotificationContent()
            content.title = "Eye Exercise Time!"
            content.body = "Open the app to complete your eye break exercise."
            content.sound = .default
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)
        }
    }

    func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
