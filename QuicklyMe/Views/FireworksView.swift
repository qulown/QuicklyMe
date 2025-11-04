import SwiftUI

struct FireworksView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            // Multiple firework bursts
            ForEach(0..<5, id: \.self) { index in
                FireworkBurst(delay: Double(index) * 0.3)
            }

            // Celebration text
            VStack {
                Text("🎉")
                    .font(.system(size: 80))
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                Text("10 Sentences!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)

                Text("+30 Points")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.yellow)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.5)
            .opacity(isAnimating ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                isAnimating = true
            }
        }
    }
}

struct FireworkBurst: View {
    let delay: Double
    @State private var isExploding = false

    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
    let particleCount = 12

    var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { index in
                FireworkParticle(
                    angle: Double(index) * (360.0 / Double(particleCount)),
                    color: colors.randomElement() ?? .yellow,
                    isExploding: isExploding
                )
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 1.0)) {
                    isExploding = true
                }
            }
        }
    }
}

struct FireworkParticle: View {
    let angle: Double
    let color: Color
    let isExploding: Bool

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .offset(x: isExploding ? cos(angle * .pi / 180) * 100 : 0,
                   y: isExploding ? sin(angle * .pi / 180) * 100 : 0)
            .opacity(isExploding ? 0.0 : 1.0)
            .scaleEffect(isExploding ? 0.5 : 1.0)
    }
}

#Preview {
    FireworksView()
}
