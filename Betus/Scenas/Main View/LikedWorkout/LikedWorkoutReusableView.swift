//
//  LikedWorkoutReusableView.swift
//  Betus
//
//  Created by Gio's Mac on 28.11.24.
//

import UIKit
import SnapKit

protocol LikeWorkoutReusableDelegate: AnyObject {
    func didPressUserInfoButton()
}

class LikedWorkoutReusableView: UICollectionReusableView {

    weak var delegate: LikeWorkoutReusableDelegate?

    private lazy var userInfoButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "userProfile"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(pressUserInfoButton), for: .touchUpInside)
        return view
    }()

    private lazy var searchButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "searchImage"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "searchImage")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
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
        addSubview(userInfoButton)
        addSubview(searchButton)
    }

    private func setupConstraints() {
        userInfoButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(10 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(12 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        searchButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(10 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-12 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }
    }

    @objc private func pressUserInfoButton() {
        delegate?.didPressUserInfoButton()
    }
}
