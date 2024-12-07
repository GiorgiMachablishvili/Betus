//
//  WorkoutInfoCell.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class WorkoutInfoCell: UICollectionViewCell {
    var selectedLevel: String?
    var workout: Workouts?

    lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.backgroundColor = .gray
        view.layer.cornerRadius = 26
        return view
    }()

    private lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.4)
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
        print("pressed like button")
        guard selectedLevel != nil else {
            print("Selected level is not set")
            return
        }

        isLiked.toggle()
        updateLikeState()

        let likeState = isLiked
        postLikeState(isLiked: likeState)
    }

    private func postLikeState(isLiked: Bool) {
        guard let userId = UserDefaults.standard.value(forKey: "userId") else { return }
        guard let workoutID = UserDefaults.standard.value(forKey: "id") else { return }
        let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/workouts/selected?user_id=\(userId)_id\(workoutID)"

//        let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/workouts/selected"

        let taskCount = workout?.taskCount
        let time = workout?.time
        let details = workout?.details
        let level = workout?.level.rawValue

        let parameters: [String: Any] = [
            "id": userId,
            "task_count": taskCount ?? 0,
            "time": time ?? 0,
            "level": level ?? "",
            "details": details ?? "",
            "isSelected": isLiked
        ]

        NetworkManager.shared.post(url: url, parameters: parameters, headers: nil) { (result: Result<WorkoutLikes>) in
            switch result {
            case .success(let response):
                print("Like updated successfully: \(response.isSelected)")
                self.fetchLikesCount(for: workoutID as! String)
            case .failure(let error):
                print("Error updating like: \(error.localizedDescription)")
                DispatchQueue.main.async {
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

    func configure(with data: Workouts, selectedLevel: String) {
        self.selectedLevel = selectedLevel
        self.workout = data

        workoutInfoView.workoutLevel.text = data.details
        workoutInfoView.taskView.taskNumberLabel.text = String(data.taskCount)
        workoutInfoView.timeView.remainingTime = Double(data.time)
        workoutInfoView.levelView.levelInfoLabel.text = data.level.rawValue

        isLiked = data.isSelected
        updateLikeState()

        fetchLikesCount(for: data.userId ?? "")

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

    private func fetchLikesCount(for workoutID: String) {
        let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/workouts/\(workoutID)/likes"

        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<[String: Int]>) in
            switch result {
            case .success(let data):
                if let likesCount = data["likesCount"] {
                    DispatchQueue.main.async {
                        self.likeViewButton.setTitle("\(likesCount)", for: .normal)
                    }
                }
            case .failure(let error):
                print("Error fetching likes count: \(error.localizedDescription)")
            }
        }
    }
}
