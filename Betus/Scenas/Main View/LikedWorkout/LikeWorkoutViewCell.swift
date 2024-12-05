//
//  LikeWorkoutViewCell.swift
//  Betus
//
//  Created by Gio's Mac on 28.11.24.
//

import UIKit
import SnapKit

class LikeWorkoutViewCell: UICollectionViewCell {
    lazy var workoutImageLikeView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "figure.australian.football.circle")
        view.layer.cornerRadius = 26
        view.isHidden = true
        return view
    }()

    lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        view.isHidden = true
        return view
    }()

    lazy var likeViewButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("44", for: .normal)
        view.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.tintColor = UIColor(hexString: "FFFFFF")
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.3)
        view.layer.cornerRadius = 22
        view.imageView?.contentMode = .scaleAspectFit
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8 * Constraint.xCoeff, bottom: 0, right: 0)
        view.addTarget(self, action: #selector(likeViewButtonTapped), for: .touchUpInside)
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(workoutImageLikeView)
        workoutImageLikeView.addSubview(workoutInfoView)
        workoutImageLikeView.addSubview(likeViewButton)
    }

    private func setupConstraints() {
        workoutImageLikeView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        workoutInfoView.snp.remakeConstraints { make in
            make.bottom.equalTo(workoutImageLikeView.snp.bottom).offset(-8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(8 * Constraint.xCoeff)
            make.height.equalTo(116 * Constraint.yCoeff)
        }

        likeViewButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-8 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
            make.width.equalTo(66 * Constraint.xCoeff)
        }
    }

    @objc func likeViewButtonTapped() {

    }

    func configure(with data: Workouts) {
        workoutInfoView.taskView.taskNumberLabel.text = String(data.taskCount)
        workoutInfoView.timeView.timerLabel.text = String(data.time)
        workoutInfoView.levelView.levelInfoLabel.text = data.level.rawValue
    }
}
