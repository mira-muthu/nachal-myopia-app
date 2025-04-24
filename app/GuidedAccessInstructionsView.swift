import SwiftUI

struct GuidedAccessInstructionsView: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("🔒 Enable Guided Access")
                .font(.title2)
                .bold()

            Text("To lock yourself into this app and prevent distractions:")
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 15) {
                Text("1. Open iOS Settings")
                Text("2. Go to Accessibility → Guided Access")
                Text("3. Turn it ON and set a passcode")
                Text("4. Triple-click the Side/Power button while in this app")
                Text("5. Tap Start in top-right")
            }

            Image(systemName: "iphone")
                .resizable()
                .scaledToFit()
                .frame(width: 100)

            Text("You can now use this app distraction-free during your session.")
                .font(.footnote)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }
}
