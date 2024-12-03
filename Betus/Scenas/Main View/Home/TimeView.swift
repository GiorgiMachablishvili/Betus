//
//  TimeView.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class TimeView: UIView {

    private lazy var timeLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Time"
        view.textColor = UIColor(hexString: "#FFFFFF66")
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 14)
        return view
    }()

    private lazy var timerLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "00:00:00"
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 12)
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
        addSubview(timeLabel)
        addSubview(timerLabel)
    }

    private func setupConstraints() {
        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(17 * Constraint.yCoeff)

        }

        timerLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-8 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(14 * Constraint.yCoeff)
        }
    }
}
