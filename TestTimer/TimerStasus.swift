//
//  TimerStasus.swift
//  TestTimer
//
//  Created by 住田雅隆 on 2022/09/18.
//

import SwiftUI

enum TimerStatus {

    case inProgress
    case paused

    var text: Text {
        switch self {
        case .inProgress:
            return Text("一時停止")
        case .paused:
            return Text("開始")
        }
    }

    mutating func start() {
        self = .inProgress
    }

    mutating func paused() {
        self = .paused
    }

    mutating func switchStatus() {
        if self == .inProgress {
            self = .paused
        } else {
            self = .inProgress
        }
    }
}

enum TimerFlow {
    case readyTime
    case trainingTime
    case intervalTime

    var text: Text {
        switch self {
        case .readyTime:
            return Text("Ready")
        case .trainingTime:
            return Text("Training")
        case .intervalTime:
            return Text("Interval")
        }
    }

    func colorChange(number: Int) -> Color {
        switch self {
        case .readyTime:
            return .blue
        case .trainingTime:
            if number <= 3 {
                return .yellow
            }else {
                return .red
            }
        case .intervalTime:
            return .green
        }
    }
}

