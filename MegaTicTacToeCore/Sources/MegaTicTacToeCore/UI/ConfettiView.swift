import SwiftUI

public struct ConfettiView: View {
    public struct Particle: Identifiable {
        public let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var color: Color
        var rotation: Double
        var opacity: Double
    }

    @State private var particles: [Particle] = []

    public init() {}

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { p in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(p.color)
                        .frame(width: p.size, height: p.size * 0.6)
                        .rotationEffect(.degrees(p.rotation))
                        .position(x: p.x, y: p.y)
                        .opacity(p.opacity)
                }
            }
            .onAppear {
                spawnParticles(in: geo.size)
            }
        }
        .allowsHitTesting(false)
    }

    private func spawnParticles(in size: CGSize) {
        let colors: [Color] = [
            Color(red: 0.0, green: 0.95, blue: 1.0),
            Color(red: 1.0, green: 0.25, blue: 0.5),
            Color(red: 1.0, green: 0.85, blue: 0.2),
            Color(red: 0.2, green: 0.9, blue: 0.4),
            Color.white
        ]

        var newParticles: [Particle] = []
        for _ in 0..<75 {
            let p = Particle(
                x: CGFloat.random(in: 20...size.width - 20),
                y: CGFloat.random(in: -40...size.height * 0.3),
                size: CGFloat.random(in: 8...16),
                color: colors.randomElement()!,
                rotation: Double.random(in: 0...360),
                opacity: 1.0
            )
            newParticles.append(p)
        }
        particles = newParticles

        // Animate particles falling down
        withAnimation(.easeOut(duration: 3.0)) {
            for i in particles.indices {
                particles[i].y += CGFloat.random(in: size.height * 0.7...size.height * 1.2)
                particles[i].rotation += Double.random(in: 180...720)
                particles[i].opacity = 0.0
            }
        }
    }
}
