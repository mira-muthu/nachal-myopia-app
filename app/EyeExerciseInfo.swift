import SwiftUI

struct EyeExerciseInfoView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("🧘 Eye Break Exercises")
                .font(.largeTitle)
                .bold()

            Text("Why Eye Exercises Matter")
                .font(.title2)
                .bold()

            VStack(alignment: .leading, spacing: 15) {
                Text("• Helps prevent eye strain and fatigue from screen time.")
                Text("• Supports healthy eye focusing and tear production.")
                Text("• Relaxes muscles and reduces myopia risk.")
                Text("• Encourages better screen habits.")
            }
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            Image(systemName: "bell.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)

            Text("Turn on notifications so we can remind you to take breaks!")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

            NavigationLink(destination: EyeExerciseView()) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationTitle("Back")
        .navigationBarTitleDisplayMode(.inline)
    }
}
