//
//  TestTimerApp.swift
//  TestTimer
//
//  Created by 住田雅隆 on 2022/08/22.
//

import SwiftUI

@main
struct TestTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(defaultReadyTime: 3, defaultTrainingTime: 5, defaultIntervalTime: 3, defaultTimesCount: 2, defaultSetCount: 2)
        }
    }
}
