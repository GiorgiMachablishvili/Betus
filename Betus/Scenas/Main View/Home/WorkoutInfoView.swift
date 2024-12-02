//
//  WorkoutInfoView.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class WorkoutInfoView: UIView {

    private lazy var workoutLevel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.latoRegular(size: 16)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .left
        view.text = "Workout Hard"
        return view
    }()

    private lazy var taskView: TaskView = {
        let view = TaskView()
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var timeView: TimeView = {
        let view = TimeView()
        return view
    }()

    private lazy var levelView: LevelView = {
        let view = LevelView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearBlur(withAlpha: 0.2)

        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(workoutLevel)
        addSubview(taskView)
        addSubview(timeView)
        addSubview(levelView)
    }

    private func setupConstraints() {
        workoutLevel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(20)
            make.leading.equalTo(snp.leading).offset(20)
            make.height.equalTo(19)
        }

        taskView.snp.remakeConstraints { make in
            make.top.equalTo(workoutLevel.snp.bottom).offset(8)
            make.trailing.equalTo(timeView.snp.leading).offset(-4)
            make.height.equalTo(49)
            make.width.equalTo(100)
        }

        timeView.snp.remakeConstraints { make in
            make.centerY.equalTo(taskView.snp.centerY)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(49)
            make.width.equalTo(100)
        }

        levelView.snp.remakeConstraints { make in
            make.centerY.equalTo(taskView.snp.centerY)
            make.leading.equalTo(timeView.snp.trailing).offset(4)
            make.height.equalTo(49)
            make.width.equalTo(100)
        }

    }
}
