//
//  HypotroichoidsView.swift
//  Hypotrochoids
//
//  Created by Danielle Kefford on 7/30/22.
//

import ScreenSaver

class HypotrochoidsView: ScreenSaverView {
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 3
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: NSRect) {
        let context = NSGraphicsContext.current?.cgContext
        let midscreenX = bounds.width/2
        let midscreenY = bounds.height/2

        let d = Int.random(in: 10...30)
        for i in 1...3 {
            let (a, b) = randomRadii()
            let scale = Double.random(in: 5...12)
            let color = randomColor()

            let path = CGMutablePath()
            for t in stride(from: 0, to: 2*Double.pi*Double(lcm(a, b)), by: 0.1) {
                let (x, y) = hypotrochoid(a: Double(a), b: Double(b), d: Double(d+i), t: t)
                if t == 0 {
                    path.move(to: CGPoint(x: midscreenX + scale*x, y: midscreenY + scale*y))
                } else {
                    path.addLine(to: CGPoint(x: midscreenX + scale*x, y: midscreenY + scale*y))
                }
            }
            path.closeSubpath()

            context?.setStrokeColor(color)
            context?.setLineWidth(2)
            context?.addPath(path)
            context?.drawPath(using: .stroke)
        }
     }

    override func animateOneFrame() {
        super.animateOneFrame()
        setNeedsDisplay(bounds)
    }

    func hypotrochoid(a: Double, b: Double, d: Double, t: Double) -> (Double, Double) {
        let x = (a - b)*cos(t) + d*cos((a - b)*t/b)
        let y = (a - b)*sin(t) - d*sin((a - b)*t/b)
        return (x, y)
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
