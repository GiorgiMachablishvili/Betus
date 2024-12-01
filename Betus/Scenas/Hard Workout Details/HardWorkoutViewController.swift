//
//  HardWorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 27.11.24.
//

import UIKit
import SnapKit

class HardWorkoutViewController: UIViewController {

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

    lazy var warningButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "danger"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: "danger")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressWarningButton), for: .touchUpInside)
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

    private lazy var workoutLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Level  Difficult"
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 12)
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(40)
        return view
    }()

    private lazy var likeView: LikeView = {
        let view = LikeView()
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.clearBlur(withAlpha: 0.2).cgColor
        view.layer.borderWidth = 1
        return view
    }()


    private lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "figure.australian.football.circle")
        view.backgroundColor = .red
        view.layer.cornerRadius = 26
        return view
    }()

    private lazy var workoutDetailsYellowButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 131, height: 41))
        view.setTitle("Workout details", for: .normal)
        view.backgroundColor = UIColor(hexString: "#E5D820")
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#1D0840"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#101538").cgColor
        view.layer.borderWidth = 6
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private lazy var workoutDetailsWhiteButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 131, height: 41))
        view.setTitle("Workout details", for: .normal)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        view.layer.cornerRadius = 22
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#1D0840"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#101538").cgColor
        view.layer.borderWidth = 6
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var reminderLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Don't miss new goals and levels in our football game - turn on notifications and keep your finger on the pulse! .  Don't miss notifi tions the"
        view.textAlignment = .center
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.2)
        view.numberOfLines = 0
        view.layer.cornerRadius = 22
        view.font = UIFont.latoRegular(size: 14)
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.textColor = UIColor(hexString: "FFFFFF").withAlphaComponent(40)
        return view
    }()

    private lazy var startWorkoutButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 216, height: 60))
        view.setTitle("Start This Workout", for: .normal)
        view.backgroundColor = UIColor(hexString: "##E5D820")
        view.layer.cornerRadius = 26
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(hexString: "#FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressStartWorkoutButton), for: .touchUpInside)
        return view
    }()

    private lazy var darkOverlay: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()

    private lazy var warningView: WarningView = {
        let view = WarningView()
        view.layer.cornerRadius = 32
        view.isHidden = true
        view.delegate = self
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
        view.addSubview(warningButton)
        view.addSubview(titleLabel)
        view.addSubview(workoutLevelLabel)
        view.addSubview(likeView)
        view.addSubview(workoutImage)
        view.addSubview(workoutInfoView)
        view.addSubview(workoutDetailsYellowButton)
        view.addSubview(reminderLabel)
        view.addSubview(workoutDetailsWhiteButton)
        view.addSubview(startWorkoutButton)
        view.addSubview(darkOverlay)
        view.addSubview(warningView)
    }

    private func setupConstraints() {
        leftButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.width.height.equalTo(44)
        }
        
        warningButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.leading.equalTo(leftButton.snp.trailing).offset(4)
            make.width.height.equalTo(44)
        }

        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(63)
            make.centerX.equalToSuperview()
            make.height.equalTo(19)
        }

        workoutLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }

        likeView.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.height.equalTo(44)
            make.width.equalTo(66)
        }
        
        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(leftButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(366)
            make.height.equalTo(287)
        }

        workoutInfoView.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(366)
            make.height.equalTo(122)
        }

        workoutDetailsYellowButton.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.bottom).offset(-23)
            make.bottom.equalTo(workoutInfoView.snp.top).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(131)
        }

        reminderLabel.snp.remakeConstraints { make in
            make.top.equalTo(workoutInfoView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(366)
            make.height.equalTo(111)
        }

        workoutDetailsWhiteButton.snp.remakeConstraints { make in
            make.top.equalTo(workoutInfoView.snp.bottom).offset(-23)
            make.bottom.equalTo(reminderLabel.snp.top).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(131)
        }

        startWorkoutButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-48)
            make.centerX.equalToSuperview()
            make.width.equalTo(216)
            make.height.equalTo(59)
        }

        darkOverlay.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        warningView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(357)
        }
    }

    @objc private func pressStartWorkoutButton() {
        let timerVC = TimerViewController()
        navigationController?.pushViewController(timerVC, animated: true)
    }

    @objc private func pressLeftButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func pressWarningButton() {
        darkOverlay.isHidden = false
        warningView.isHidden = false
    }
}

extension HardWorkoutViewController: WarningViewDelegate {
    func didPressCancelButton() {
        darkOverlay.isHidden = true
        warningView.isHidden = true
    }
    

}
