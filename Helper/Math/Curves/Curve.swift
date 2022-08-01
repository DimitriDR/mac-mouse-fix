//
// --------------------------------------------------------------------------
// Curve.swift
// Created for Mac Mouse Fix (https://github.com/noah-nuebling/mac-mouse-fix)
// Created by Noah Nuebling in 2021
// Licensed under MIT
// --------------------------------------------------------------------------
//

import Cocoa

@objc class Curve: NSObject {
    
    typealias Point = Vector
    
    @objc func evaluate(at x: Double) -> Double { fatalError() }
    /// ^ Animator.swift expects this to pass through (0,0) and (1,1)
    
    @objc func stringTrace(startX x0: Double, endX x1: Double, nOfSamples: Int) -> String {
        
        let trace = traceAsPoints(startX: x0, endX: x1, nOfSamples: nOfSamples, bias: 1.0)
        var traceStr: String = String()
        
        for p in trace {
            traceStr.append("(\(p.x),\(p.y))\n")
        }
        
        return traceStr
    }
    
    @objc func traceSpeed(startX x0: Double, endX x1: Double, nOfSamples: Int, bias: Double) -> [[Double]] {
        /// Our AccelerationCurves is defined in terms of pointerSens(mouseSpeed)
        ///  But Apple's accelerationCurves are defined as pointerSpeed(mouseSpeed). This function let's us create a trace of that
        return traceAsPoints(startX: x0, endX: x1, nOfSamples: nOfSamples, bias: bias).map { p in
            let x = p.x
            let y = p.y * x
            return [x, y]
        }
    }
    
    @objc func trace(startX x0: Double, endX x1: Double, nOfSamples: Int, bias: Double) -> [[Double]] {
        return traceAsPoints(startX: x0, endX: x1, nOfSamples: nOfSamples, bias: bias).map { p in [p.x, p.y] }
    }
    
    func traceAsPoints(startX x0: Double, endX x1: Double, nOfSamples: Int, bias: Double) -> [Point] {
        
        /// `bias` makes the algorithm take more samples at smaller x values. 1.0 is no bias.
        
        var trace: Array<Point> = Array()
        
        let xInterval = Interval(x0, x1)
        
        for i in 0..<nOfSamples {
            let unitI = Math.scale(value: Double(i), from: Interval(location: 0, length: Double(nOfSamples-1)), to: .unitInterval)
            let biasedI = pow(Double(unitI), bias)
            let x = Math.scale(value: biasedI, from: .unitInterval, to: xInterval)
            let y = evaluate(at: x)
            
            trace.append(Point(x: x, y: y))
            
        }
        
        return trace;
    }
}

@objc class AccelerationCurve: Curve {
    
//    @objc func createAccelerationTable(numberOfPoints: Int, endX x1: Double, accelIndex: Double) -> CFData { /// This is unused I think
//        let trace = self.trace(startX: 0, endX: x1, nOfSamples: numberOfPoints)
//        let traceNS = trace.map { p in
//            return [NSNumber(value: p[0]), NSNumber(value: p[1])]
//        }
//        let table = createAccelerationTableWithArray(traceNS, accelIndex)
//        return table.takeRetainedValue()
//    }
}