//
//  WorkoutInfoCell.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class WorkoutInfoCell: UICollectionViewCell {
    private lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "figure.australian.football.circle")
        view.backgroundColor = .red
        view.layer.cornerRadius = 26
        return view
    }()

    private lazy var workoutInfoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        view.layer.cornerRadius = 26
        return view
    }()

    private lazy var likeView: LikeView = {
        let view = LikeView()
        view.layer.cornerRadius = 26
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
        addSubview(workoutImage)
        workoutImage.addSubview(workoutInfoView)
        workoutImage.addSubview(likeView)
    }

    private func setupConstraints() {
        workoutImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        workoutInfoView.snp.remakeConstraints { make in
            make.bottom.equalTo(workoutImage.snp.bottom).offset(-8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(116)
        }

        likeView.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8)
            make.trailing.equalTo(snp.trailing).offset(-8)
            make.height.equalTo(44)
            make.width.equalTo(66)
        }
    }
}
