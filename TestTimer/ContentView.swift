//
//  ContentView.swift
//  TestTimer
//
//  Created by 住田雅隆 on 2022/08/22.
//

import SwiftUI

struct ContentView: View {
    // デフォルトのカウント
    let defaultReadyTime: Int
    let defaultTrainingTime: Int
    let defaultIntervalTime: Int
    let defaultTimesCount: Int
    let defaultSetCount: Int

    // 残りのカウント
    @State var readyTimeRemaining: Int
    @State var trainingTimeRemaining: Int
    @State var intervalTimeRemaining: Int
    @State var trainingCountRemaining: Int
    @State var setCountRemaining: Int
    // タイマー
    @State var timer: Timer?
    @State var timerStatus: TimerStatus = .paused
    @State var timerFlow: TimerFlow = .trainingTime // 初期ディスプレイ表示用
    let notificationCenterDefault = NotificationCenter.default

    init(defaultReadyTime: Int, defaultTrainingTime: Int, defaultIntervalTime: Int, defaultTimesCount: Int, defaultSetCount: Int) {
        self.defaultReadyTime = defaultReadyTime
        self.defaultTrainingTime = defaultTrainingTime
        self.defaultIntervalTime = defaultIntervalTime
        self.defaultTimesCount = defaultTimesCount
        self.defaultSetCount = defaultSetCount

        readyTimeRemaining = defaultReadyTime
        trainingTimeRemaining = defaultTrainingTime
        intervalTimeRemaining = defaultIntervalTime
        trainingCountRemaining = defaultTimesCount
        setCountRemaining = defaultSetCount
    }

    var body: some View {
        VStack {
            timerFlow.text
                .font(.largeTitle)
                .foregroundColor(timerFlow.colorChange(number: trainingTimeRemaining))
                .padding()
            Text(String(setupNumber()))
                .font(.largeTitle)
                .foregroundColor(timerFlow.colorChange(number: trainingTimeRemaining))
                .padding()
            HStack(spacing: 50) {
                Text("Set:\(setCountRemaining)")
                    .padding()
                Text("Times:\(trainingCountRemaining)")
                    .padding()
            }
            .padding()

            HStack(spacing: 50) {
                Button(action: {
                    //ボタンの切り替え
                    timerStatus.switchStatus()

                    switch timerStatus {
                    case .inProgress:
                        // 一時停止から再開した時readyTimeから走らせないように
                        if readyTimeRemaining > 0 {
                            timerFlow = .readyTime
                        }

                        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                                     repeats: true) { _ in

                            timerStart()
                        }
                    case .paused:
                        timer?.invalidate()
                    }
                }) {
                    timerStatus.text
                }

                Button(action: {
                    timerReset()
                    timer?.invalidate()

                }) {
                    Text("停止")
                }
            }
        }
    }

    func timerStart() {
        guard timerStatus == .inProgress else { return }
        switch timerFlow {
        case .readyTime:

            readyTimeRemaining -= 1
            if readyTimeRemaining < 1 {
                timerFlow = .trainingTime
            }
        case .trainingTime:

            trainingTimeRemaining -= 1
            if trainingTimeRemaining < 1 {
                timerFlow = .intervalTime
            }
        case .intervalTime:
            intervalTimeRemaining -= 1
            if intervalTimeRemaining < 1 { //インターバルタイマーが0ならトレーニングカウントダウン中に戻る
                trainingCountRemaining -= 1
                configureTrainingSet()
                timerFlow = .trainingTime
                if trainingCountRemaining < 1 { //回数が0ならセット数を減らす
                    setCountRemaining -= 1
                    trainingCountRemaining = defaultTimesCount
                    timerFlow = .trainingTime
                    if setCountRemaining < 1 { //セット数が0なら終了処理へ
                        timerReset()
                    }
                }
            }
        }
    }

    private func timerReset() {
        timerStatus.paused()
        timer?.invalidate()
        initializeTrainingSet()
    }

    private func configureTrainingSet() {
        trainingTimeRemaining = defaultTrainingTime
        intervalTimeRemaining = defaultIntervalTime
    }

    //トレーニングのカウントをイニシャライズ（初期化）
    private func initializeTrainingSet() {
        readyTimeRemaining = defaultReadyTime
        trainingTimeRemaining = defaultTrainingTime
        intervalTimeRemaining = defaultIntervalTime
        trainingCountRemaining = defaultTimesCount
        setCountRemaining = defaultSetCount
        timerFlow = .trainingTime
    }

    private func stopTimerInAppBackground() {
        //バックグラウンドに移った場合はリセット
        notificationCenterDefault
            .addObserver(
                forName: UIApplication.willResignActiveNotification,
                object: nil,
                queue: nil
            ) { [self] _ in
                self.timerStatus.paused()
                self.timer?.invalidate()
            }
    }

    func setupNumber() -> Int {
        switch timerFlow {
        case .readyTime:
            return readyTimeRemaining
        case .trainingTime:
            return trainingTimeRemaining
        case .intervalTime:
            return intervalTimeRemaining
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(defaultReadyTime: 3, defaultTrainingTime: 5, defaultIntervalTime: 3, defaultTimesCount: 2, defaultSetCount: 2)
    }
}
