//
//  TimerViewController.swift
//  Betus
//
//  Created by Gio's Mac on 26.11.24.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {
    private var timer: Timer?
    private var duration: TimeInterval = 9
    private var remainingTime: TimeInterval = 9
    private var isTimerRunning = false

    lazy var leftButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "backArrow"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: "backArrow")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressLeftButton), for: .touchUpInside)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Hard Workout"
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 16)
        view.textColor = UIColor(hexString: "FFFFFF")
        return view
    }()

    private lazy var likeView: LikeView = {
        let view = LikeView()
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.clearBlur(withAlpha: 0.2).cgColor
        view.layer.borderWidth = 1
        return view
    }()


    private lazy var circularProgressView: CircularProgressView = {
        let view = CircularProgressView()
        view.trackColor = UIColor.lightGray
        view.progressColor = UIColor(hexString: "#E5D820")
        view.setProgress(to: 1.0)
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let view = UILabel()
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        view.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        view.font = UIFont.boldSystemFont(ofSize: 32)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
        return view
    }()

    private lazy var beshOnTheSportImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "beshOnTheSport")
        view.contentMode = .scaleAspectFit
        return view
    }()


    private lazy var startButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 216, height: 60))
        view.setTitle("Play", for: .normal)
        view.backgroundColor = UIColor(hexString: "#E5D820")
        view.layer.cornerRadius = 26
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(didPressStartButton), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()
        self.navigationItem.hidesBackButton = true
    }

    private func setup() {
        view.addSubview(leftButton)
        view.addSubview(titleLabel)
        view.addSubview(likeView)
        view.addSubview(circularProgressView)
        view.addSubview(timeLabel)
        view.addSubview(beshOnTheSportImage)
        view.addSubview(startButton)
    }

    private func setupConstraints() {
        leftButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.width.height.equalTo(44)
        }

        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(63)
            make.centerX.equalToSuperview()
            make.height.equalTo(19)
        }

        likeView.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.height.equalTo(44)
            make.width.equalTo(66)
        }

        circularProgressView.snp.remakeConstraints { make in
            make.top.equalTo(leftButton.snp.bottom).offset(104)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(300)
        }

        timeLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(circularProgressView.snp.centerX)
            make.centerY.equalTo(circularProgressView.snp.centerY)
        }

        beshOnTheSportImage.snp.remakeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(103)
            make.width.equalTo(342)
        }

        startButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-48)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(115)
            make.height.equalTo(59)
        }
    }

    @objc private func didPressStartButton() {
        if startButton.title(for: .normal) == "Complete" {
            let mainViewController = MainViewController()
            navigationController?.pushViewController(mainViewController, animated: true)
        } else if isTimerRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        isTimerRunning = true
        startButton.setTitle("Pause", for: .normal)
        startButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                let progress = self.remainingTime / self.duration
                self.circularProgressView.setProgress(to: progress)
                self.updateTimeLabel()
            } else {
                self.timer?.invalidate()
                self.isTimerRunning = false
                self.startButton.setTitle("Complete", for: .normal)
                self.startButton.backgroundColor = UIColor(hexString: "#E5D820")
            }
        }
    }

    private func pauseTimer() {
        isTimerRunning = false
        startButton.setTitle("Play", for: .normal)
        startButton.backgroundColor = UIColor(hexString: "E5D820")

        timer?.invalidate()
    }

    private func updateTimeLabel() {
        let hours = Int(remainingTime) / 3600
           let minutes = (Int(remainingTime) % 3600) / 60
           let seconds = Int(remainingTime) % 60
           timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    @objc private func pressLeftButton() {
        navigationController?.popViewController(animated: true)
    }
}