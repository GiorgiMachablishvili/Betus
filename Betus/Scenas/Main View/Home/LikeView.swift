//
//  LikeView.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

class LikeView: UIView {

    private lazy var numberOfLikesLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "44"
        view.textColor = UIColor(hexString: "FFFFFF")
        view.textAlignment = .center
        view.font = UIFont.latoRegular(size: 12)
        return view
    }()

    private lazy var likeImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "heart")
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
        addSubview(numberOfLikesLabel)
        addSubview(likeImage)
    }

    private func setupConstraints() {
        numberOfLikesLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(snp.leading).offset(14)
            make.height.width.equalTo(14)
        }

        likeImage.snp.remakeConstraints { make in
            make.centerY.equalTo(numberOfLikesLabel.snp.centerY)
            make.leading.equalTo(numberOfLikesLabel.snp.trailing).offset(8)
            make.height.width.equalTo(14)
        }
    }
}
