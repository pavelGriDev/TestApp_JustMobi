//
//  TaskOneViewController.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 18.07.25.
//

import UIKit

class TaskOneViewController: UIViewController {
    
    enum Appearance {
        static let circleGiftViewWidth: CGFloat = 168
    }
    
    private lazy var giftView = CircleWithGiftView(imageName: .giftBoxRed)
    
    private var timeLimit = 1200
    private weak var giftTimer: Timer?
    
    // MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        giftView.startAnimation()
        giftView.setTime(timeLimit)
        createTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        giftView.stopAnimation()
        stopTimer()
    }
}

// MARK: - Private Methods

private extension TaskOneViewController {
    
    func setup() {
        view.backgroundColor = .white
        view.addSubviewsForAutoLayout(giftView)
        let giftViveTapGesture = UITapGestureRecognizer(target: self, action: #selector(giftTapGesture))
        giftView.addGestureRecognizer(giftViveTapGesture)
    }
    
    @objc func giftTapGesture() {
        print("Show a gift...")
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            giftView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            giftView.widthAnchor.constraint(equalToConstant: Appearance.circleGiftViewWidth),
            giftView.heightAnchor.constraint(equalTo: giftView.widthAnchor),
        ])
    }
}

// MARK: - Timer

private extension TaskOneViewController {
    
    func createTimer() {
        stopTimer()
        giftTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        giftTimer?.tolerance = 0.4
    }
    
    @objc func timerHandler() {
        timeLimit -= 1
        giftView.setTime(timeLimit)
    }
    
    func stopTimer() {
        giftTimer?.invalidate()
        giftTimer = nil
    }
}
