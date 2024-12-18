//
//  MotionManager.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

#if os(iOS)
import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    
    @Published var x: Double = 0.0
    @Published var y: Double = 0.0
    
    private var timer: Timer?


    init() {
#if targetEnvironment(simulator)
//        startMockMotionUpdates()
#else
        startMotionUpdates()
#endif
    }
    
    func startMockMotionUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Simulate a simple oscillating motion
            let time = Date().timeIntervalSince1970
            self.x = sin(time)
            self.y = cos(time)
        }
    }
    
    func startMotionUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0 // 60 Hz
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard let self = self, let data = data else { return }
                
                // Update the x and y values based on accelerometer data
                self.x = data.acceleration.x
                self.y = data.acceleration.y
            }
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}
#endif
