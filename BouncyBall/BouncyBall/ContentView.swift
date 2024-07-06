import SwiftUI


struct ContentView: View {
    @State private var position = CGPoint(x: 100, y: 100)
    @State private var velocity = CGPoint(x: 400, y: 300)
    @State private var currentColorIndex: Int = 0
    private let colors: [Color] = [.white, .red, .blue, .green, .yellow]

    let sizeUnit: CGFloat = 20
    let imageSize: CGFloat = UIScreen.main.bounds.width * 0.25
    let containerSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    let timer = Timer.publish(every: 1/120, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            Color.black
            ZStack {
                colors[currentColorIndex]
                    .mask(
                        Image("DVDlogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    )
                    .frame(width: imageSize, height: imageSize * 0.6)
                    .position(position)
            }
            .onReceive(timer) { _ in
                self.updateBallPosition()
            }
        }
        .ignoresSafeArea()
    }
    
    private func updateBallPosition() {
        let timeStep = 1.0 / 320.0
        
        var newPosition = position
        newPosition.x += CGFloat(velocity.x) * CGFloat(timeStep)
        newPosition.y += CGFloat(velocity.y) * CGFloat(timeStep)
        
        var newVelocity = velocity
        
        if newPosition.x <= imageSize / 2 || newPosition.x >= containerSize.width - imageSize / 2 {
            newVelocity.x = -newVelocity.x
            updateColor()
        }
        
        if newPosition.y <= imageSize * 0.6 / 2 || newPosition.y >= containerSize.height - imageSize * 0.6 / 2 {
            newVelocity.y = -newVelocity.y
            updateColor()
        }
        
        position = CGPoint(
            x: min(max(newPosition.x, imageSize * 0.5), containerSize.width),
            y: min(max(newPosition.y, imageSize * 0.6 / 2), containerSize.height)
        )
        velocity = newVelocity
    }
    
    private func updateColor() {
        currentColorIndex = (currentColorIndex + 1) % colors.count
    }
}

#Preview {
    ContentView()
}
