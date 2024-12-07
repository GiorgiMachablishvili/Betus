//
//  LikedWorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class LikedWorkoutViewController: UIViewController {

    var workoutImage: UIImage?
    var workoutData: [Workouts] = []
    var likedWorkouts: [WorkoutLikes] = []

    var likeWorkoutCell = LikeWorkoutViewCell()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 24 * Constraint.xCoeff, height: 287 * Constraint.yCoeff)
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 65 * Constraint.yCoeff)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10 * Constraint.yCoeff, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(LikedWorkoutReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "LikedWorkoutReusableView")
        view.register(LikeWorkoutViewCell.self, forCellWithReuseIdentifier: "LikeWorkoutViewCell")
        return view
    }()

    private lazy var infoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.text = "You don't have any selected workouts yet"
        view.textColor = UIColor(hexString: "FFFFFF")
        view.font = UIFont.latoBold(size: 16)
        view.numberOfLines = 2
        view.isHidden = true
        return view
    }()

    private lazy var forOrderingStoreLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.text = "In order for us to store your favourites you must be logged in."
        view.textColor = UIColor(hexString: "FFFFFF")
        view.font = UIFont.latoBold(size: 16)
        view.numberOfLines = 2
        view.isHidden = true
        return view
    }()

    private lazy var signInWithAppleButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Sign In with Apple", for: .normal)
        view.setTitleColor(UIColor(hexString: "000000"), for: .normal)
        view.backgroundColor = UIColor(hexString: "FFFFFF")
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(hexString: "FFFFFF").cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: "appleLogo"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = UIEdgeInsets(top: 16 * Constraint.yCoeff, left: -5 * Constraint.xCoeff, bottom: 16 * Constraint.yCoeff, right: 0)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addTarget(self, action: #selector(clickSignInWithAppleButton), for: .touchUpInside)
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()

        fetchLikedWorkouts()
    }

    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(infoLabel)
        view.addSubview(forOrderingStoreLabel)
        view.addSubview(signInWithAppleButton)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.top.equalTo(view.snp.top).offset(10 * Constraint.yCoeff)
            make.bottom.equalToSuperview()
        }

        infoLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(230 * Constraint.xCoeff)
        }

        forOrderingStoreLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(367 * Constraint.yCoeff)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(366 * Constraint.xCoeff)
        }

        signInWithAppleButton.snp.remakeConstraints { make in
            make.top.equalTo(forOrderingStoreLabel.snp.bottom).offset(16 * Constraint.yCoeff)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(366 * Constraint.xCoeff)
            make.height.equalTo(56 * Constraint.yCoeff)
        }
    }

    private func fetchLikedWorkouts() {
        let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/workouts/selected"
        
        NetworkManager.shared.post(url: url, parameters: nil, headers: nil) { (result: Result<[WorkoutLikes]>) in
                switch result {
                case .success(let workouts):
                    let likedWorkouts = workouts.filter { $0.isSelected == true }
                DispatchQueue.main.async {
                    if likedWorkouts.isEmpty {
                        self.likeWorkoutCell.workoutInfoView.isHidden = true
                        self.likeWorkoutCell.likeViewButton.isHidden = true
                        self.likeWorkoutCell.workoutInfoView.isHidden = true
                        self.infoLabel.isHidden = false
                    } else {
                        self.likeWorkoutCell.workoutInfoView.isHidden = false
                        self.likeWorkoutCell.likeViewButton.isHidden = false
                        self.likeWorkoutCell.workoutInfoView.isHidden = false
                        self.infoLabel.isHidden = true
                    }
                    self.likedWorkouts = likedWorkouts
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching liked workouts: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.infoLabel.isHidden = false
                    self.collectionView.isHidden = true
                }
            }
        }
    }

    @objc private func clickSignInWithAppleButton() {

    }
}

extension LikedWorkoutViewController: LikeWorkoutReusableDelegate {
    func didPressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }
}

extension LikedWorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        likedWorkouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LikeWorkoutViewCell.self), for: indexPath) as? LikeWorkoutViewCell else {
            return UICollectionViewCell()
        }
        let workout = workoutData[indexPath.row]
        cell.configure(with: workout)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "LikedWorkoutReusableView",
                for: indexPath
            ) as! LikedWorkoutReusableView
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hardWorkoutVC = HardWorkoutViewController()
        navigationController?.pushViewController(hardWorkoutVC, animated: true)
    }
}
