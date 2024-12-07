//
//  WorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class WorkoutViewController: UIViewController {

    private var workouts: [Workouts] = []
    private var allWorkouts: [Workouts] = []
    private var displayedWorkouts: [Workouts] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 24, height: 287)
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderView")
        view.register(WorkoutInfoCell.self, forCellWithReuseIdentifier: "WorkoutInfoCell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()

        fetchWorkoutCurrentUserInfo()
    }

    private func setup() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(view.snp.top).offset(10)
            make.bottom.equalTo(view.snp.bottom).offset(-5)
        }
    }

    private func fetchWorkoutCurrentUserInfo() {
        let id = UserDefaults.standard.value(forKey: "userId")
        let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/workouts/user/\(id ?? "")"

        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<[Workouts]>) in
            switch result {
            case .success(let workouts):
                self.allWorkouts = workouts
                self.displayedWorkouts = workouts
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching workouts: \(error.localizedDescription)")
            }
        }
    }
}

extension WorkoutViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let bottomOffsetThreshold: CGFloat = 80.0

        if scrollView.contentOffset.y + frameHeight >= contentHeight {
            scrollView.contentInset.bottom = bottomOffsetThreshold
        } else {
            scrollView.contentInset.bottom = 0
        }
    }
}

extension WorkoutViewController: HomeHeaderViewDelegate {
    func didPressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }

    func filterWorkouts(by level: Workouts.Level) {
        guard level != .all else {
            displayedWorkouts = allWorkouts
            collectionView.reloadData()
            return
        }
        displayedWorkouts = allWorkouts.filter { $0.level.rawValue.lowercased() == level.rawValue.lowercased()}
        collectionView.reloadData()
    }

    func searchWorkouts(with searchText: String) {
        guard !searchText.isEmpty else {
            displayedWorkouts = allWorkouts
            collectionView.reloadData()
            return
        }
        displayedWorkouts = allWorkouts.filter { workout in
            workout.details.lowercased().contains(searchText.lowercased())
            /*$0.details.lowercased().contains(searchText.lowercased())*/
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedWorkouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WorkoutInfoCell.self), for: indexPath) as? WorkoutInfoCell else {
            return UICollectionViewCell()
        }
        let workout = displayedWorkouts[indexPath.row]
        let selectedLevel = workout.level.rawValue
        cell.configure(with: workout, selectedLevel: selectedLevel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HomeHeaderView",
                for: indexPath
            ) as! HomeHeaderView
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WorkoutInfoCell,
              let selectedImage = cell.workoutImage.image else { return }
        let selectedWorkout = displayedWorkouts[indexPath.row]
        let hardWorkoutVC = HardWorkoutViewController()

        hardWorkoutVC.workoutImage.image = selectedImage
        hardWorkoutVC.workoutData = selectedWorkout
        navigationController?.pushViewController(hardWorkoutVC, animated: true)
    }
}
