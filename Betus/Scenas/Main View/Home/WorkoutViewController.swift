//
//  WorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class WorkoutViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 24, height: 287)
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderView")
        view.register(WorkoutInfoCell.self, forCellWithReuseIdentifier: "WorkoutInfoCell")
        return view
    }()

    private var workoutData: [WorkoutInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()

        fetchWorkoutInfo()
    }

    private func setup() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(view.snp.top).offset(10)
            make.bottom.equalToSuperview()
        }
    }

    private func fetchWorkoutInfo() {
           let userId = "3fa85f64-5717-4562-b3fc-2c963f66afa6"
           let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/users/\(userId)"

           NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<WorkoutInfo>) in
               switch result {
               case .success(let data):
                   self.workoutData = [data]
                   DispatchQueue.main.async {
                       self.collectionView.reloadData()
                   }
               case .failure(let error):
                   print("Error fetching workout info: \(error.localizedDescription)")
               }
           }
       }
}

extension WorkoutViewController: HomeHeaderViewDelegate {
    func didPressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }
}

extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        workoutData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WorkoutInfoCell.self), for: indexPath) as? WorkoutInfoCell else {
            return UICollectionViewCell()
        }
        let workout = workoutData[indexPath.row]
        cell.configure(with: workout.image)
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
        let hardWorkoutVC = HardWorkoutViewController()
        navigationController?.pushViewController(hardWorkoutVC, animated: true)
    }
}



