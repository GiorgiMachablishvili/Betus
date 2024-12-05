//
//  WorkoutInfoCell.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class WorkoutInfoCell: UICollectionViewCell {
    lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .gray
        view.layer.cornerRadius = 26
        return view
    }()

    private lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        return view
    }()

    private lazy var likeViewButton: NonPropagatingButton = {
        let view = NonPropagatingButton(type: .system)
        view.setTitle("44", for: .normal)
        view.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.tintColor = UIColor(hexString: "FFFFFF")
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.3)
        view.layer.cornerRadius = 22
        view.imageView?.contentMode = .scaleAspectFit
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        view.addTarget(self, action: #selector(likeViewButtonTapped), for: .touchUpInside)
        return view
    }()

    private var didTapCell: (() -> Void)?

    private var isLiked = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = likeViewButton.convert(point, from: self)
        if likeViewButton.bounds.contains(convertedPoint) {
            return likeViewButton
        }
        return super.hitTest(point, with: event)
    }

    private func setup() {
        contentView.addSubview(workoutImage)
        workoutImage.addSubview(workoutInfoView)
        workoutImage.addSubview(likeViewButton)
    }

    private func setupConstraints() {
        workoutImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        workoutInfoView.snp.remakeConstraints { make in
            make.bottom.equalTo(workoutImage.snp.bottom).offset(-8 * Constraint.xCoeff)
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
        isLiked.toggle()
        updateLikeState()

        let likeState = isLiked
        postLikeState(isLiked: likeState)
    }

    private func postLikeState(isLiked: Bool) {
        // Replace with the correct workout ID and URL
        guard let workoutID = workoutInfoView.taskView.taskNumberLabel.text else { return }
        let url = "https://example.com/api/v1/workouts/\(workoutID)/like"
        guard let userId = UserDefaults.standard.value(forKey: "userId") else { return }

        // Prepare parameters
        let parameters: [String: Any] = [
            "like": isLiked,
            "user_id": userId
        ]

        // Send POST request
        NetworkManager.shared.post(url: url, parameters: parameters, headers: nil) { (result: Result<LikeResponse>) in
            switch result {
            case .success(let response):
                print("Like updated successfully: \(response.like)")
            case .failure(let error):
                print("Error updating like: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    // Revert the like state if the request fails
                    self.isLiked.toggle()
                    self.updateLikeState()
                }
            }
        }
    }

    private func updateLikeState() {
        if isLiked {
            likeViewButton.setImage(UIImage(named: "heartFilled")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
            if let likes = Int(likeViewButton.title(for: .normal) ?? "0") {
                likeViewButton.setTitle("\(likes + 1)", for: .normal)
            }
        } else {
            likeViewButton.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
            if let likes = Int(likeViewButton.title(for: .normal) ?? "0"), likes > 0 {
                likeViewButton.setTitle("\(likes - 1)", for: .normal)
            }
        }
    }
    
    func configure(with data: Workouts) {
        workoutInfoView.workoutLevel.text = data.details
        workoutInfoView.taskView.taskNumberLabel.text = String(data.taskCount)
        workoutInfoView.timeView.remainingTime = Double(data.time)
        workoutInfoView.levelView.levelInfoLabel.text = data.level.rawValue

        if let url = URL(string: data.image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.workoutImage.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.workoutImage.image = UIImage(named: "placeholderImage")
                    }
                }
            }
        } else {
            self.workoutImage.image = UIImage(named: "placeholderImage")
        }
    }
}
