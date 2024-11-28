//
//  MainBottomButtonView.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class MainBottomButtonView: UIView {

    weak var delegate: MainViewController?

    lazy var homeButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "home"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "home")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressHomeButton), for: .touchUpInside)
        return view
    }()

    lazy var infoWorkOutButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "heart"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "heart")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressinfoWorkOutButton), for: .touchUpInside)
        return view
    }()

    lazy var plusButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "plus"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "plus")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressPlusButton), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        setup()
        setupConstraints()
        homeButton.backgroundColor = UIColor(hexString: "E5D820")
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(homeButton)
        addSubview(infoWorkOutButton)
        addSubview(plusButton)
    }

    private func setupConstraints() {
        homeButton.snp.remakeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.trailing.equalTo(infoWorkOutButton.snp.leading).offset(-40 * Constraint.xCoeff)
            make.height.width.equalTo(44 * Constraint.yCoeff)
        }

        infoWorkOutButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(homeButton.snp.centerY)
            make.height.width.equalTo(44 * Constraint.yCoeff)
        }

        plusButton.snp.remakeConstraints { make in
            make.leading.equalTo(infoWorkOutButton.snp.trailing).offset(40 * Constraint.xCoeff)
            make.centerY.equalTo(homeButton.snp.centerY)
            make.height.width.equalTo(44 * Constraint.yCoeff)
        }
    }

    //TODO: button image size changes when press button
    private func resetButtonImages() {
        homeButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        infoWorkOutButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        plusButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
    }

    // MARK: - Button Action Methods
    @objc private func pressHomeButton() {
        resetButtonImages()
        homeButton.backgroundColor = UIColor(hexString: "E5D820")
        delegate?.pressHomeButton()
    }

    @objc private func pressinfoWorkOutButton() {
        resetButtonImages()
        infoWorkOutButton.backgroundColor = UIColor(hexString: "E5D820")
        delegate?.pressSearchButton()
    }

    @objc private func pressPlusButton() {
        resetButtonImages()
        plusButton.backgroundColor = UIColor(hexString: "E5D820")
        delegate?.pressPlusButton()
    }
}

