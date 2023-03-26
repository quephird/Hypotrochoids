//
//  HypotroichoidsView.swift
//  Hypotrochoids
//
//  Created by Danielle Kefford on 7/30/22.
//

import ScreenSaver

class HypotrochoidsView: ScreenSaverView {
    var d: Int = 0
    var radii: [(Int, Int)] = []
    var scales: [Double] = []
    var colors: [CGColor] = []
    var dts: [Double] = []
    var timer: Date = Date()
    var frameNumber = 0

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.randomizeAllMetrics()
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else {
            fatalError("Unable to obtain core graphics context")
        }

        let midscreenX = bounds.width/2
        let midscreenY = bounds.height/2

        for i in 0...2 {
            let (a, b) = self.radii[i]
            let scale = scales[i]
            let color = colors[i]

            let path = CGMutablePath()
            let dt = self.dts[i]*Double(frameNumber)
            for t in stride(from: 0, to: 2*Double.pi*Double(lcm(a, b)), by: 0.1) {
                var (x, y) = hypotrochoid(a: Double(a), b: Double(b), d: Double(d+i), t: t)
                (x, y) = (x*cos(dt) - y*sin(dt), y*cos(dt) + x*sin(dt))

                if t == 0 {
                    path.move(to: CGPoint(x: midscreenX + scale*x, y: midscreenY + scale*y))
                } else {
                    path.addLine(to: CGPoint(x: midscreenX + scale*x, y: midscreenY + scale*y))
                }
            }
            path.closeSubpath()

            context.setStrokeColor(color)
            context.setLineWidth(2)
            context.addPath(path)
            context.drawPath(using: .stroke)
        }
     }

    override func animateOneFrame() {
        super.animateOneFrame()
        self.frameNumber += 1

        let elapsedTime = -timer.timeIntervalSinceNow
        if elapsedTime >= 5.0 {
            self.frameNumber = 0
            self.timer = Date()
            self.randomizeAllMetrics()
        }

        setNeedsDisplay(bounds)
    }

    func hypotrochoid(a: Double, b: Double, d: Double, t: Double) -> (Double, Double) {
        let x = (a - b)*cos(t) + d*cos((a - b)*t/b)
        let y = (a - b)*sin(t) - d*sin((a - b)*t/b)
        return (x, y)
    }

    func randomizeAllMetrics() {
        self.radii.removeAll()
        self.scales.removeAll()
        self.colors.removeAll()
        self.dts.removeAll()

        self.d = Int.random(in: 10...30)
        for _ in 1...3 {
            self.radii.append(self.randomRadii())
            self.scales.append(Double.random(in: 5...12))
            self.colors.append(self.randomColor())
            self.dts.append(Double.random(in: -0.05...0.05))
        }
    }

    func randomRadii() -> (Int, Int) {
        let a = Int.random(in: 5...20)
        let b = Int.random(in: 5...20)
        if min(a, b) == gcd(a, b) {
            return randomRadii()
        }
        return (a, b)
    }

    func randomColor() -> CGColor {
        let h = CGFloat.random(in: 0...1)
        let s = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0.5...1)
        return NSColor(hue: h, saturation: s, brightness: b, alpha: 1.0).cgColor
    }

    func lcm(_ x: Int, _ y: Int) -> Int {
        return x*y/gcd(x, y)
    }

    func gcd(_ x: Int, _ y: Int) -> Int {
        if x < y {
            return gcd(y, x)
        }

        let r = x % y
        if r == 0 {
            return y
        } else {
            return gcd(y, r)
        }
    }
}
