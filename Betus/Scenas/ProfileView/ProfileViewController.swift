//
//  ProfileViewController.swift
//  Betus
//
//  Created by Gio's Mac on 26.11.24.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    private lazy var leftButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "backArrow"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "backArrow")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressLeftButton), for: .touchUpInside)
        return view
    }()

    private lazy var userDeleteButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "profileDelete"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        return view
    }()

    private lazy var termsOfUseButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366, height: 59))
        view.setTitle("Terms of use", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressTermsOfUserButton), for: .touchUpInside)
        return view
    }()

    private lazy var privacyPolicyButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366, height: 59))
        view.setTitle("Privacy policy", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var supportButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366, height: 59))
        view.setTitle("Support", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var rateUsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366, height: 59))
        view.setTitle("Rate US", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var deleteAccountButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 366, height: 59))
        view.setTitle("Delete Account", for: .normal)
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 16)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
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
        view.imageEdgeInsets = UIEdgeInsets(top: 16, left: -5, bottom: 16, right: 0)
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
        self.navigationItem.hidesBackButton = true
    }

    private func setup() {
        view.addSubview(leftButton)
        view.addSubview(userDeleteButton)
        view.addSubview(termsOfUseButton)
        view.addSubview(privacyPolicyButton)
        view.addSubview(supportButton)
        view.addSubview(rateUsButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(signInWithAppleButton)
    }

    private func setupConstraints() {
        leftButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.width.height.equalTo(44)
        }

        userDeleteButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.width.height.equalTo(44)
        }

        termsOfUseButton.snp.remakeConstraints { make in
            make.top.equalTo(userDeleteButton.snp.bottom).offset(185)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(59)
        }

        privacyPolicyButton.snp.remakeConstraints { make in
            make.top.equalTo(termsOfUseButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(59)
        }

        supportButton.snp.remakeConstraints { make in
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(59)
        }

        rateUsButton.snp.remakeConstraints { make in
            make.top.equalTo(supportButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(59)
        }

        deleteAccountButton.snp.remakeConstraints { make in
            make.top.equalTo(rateUsButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(59)
        }

        signInWithAppleButton.snp.remakeConstraints { make in
            make.top.equalTo(rateUsButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(59)
        }
    }
    
    @objc private func pressLeftButton() {
        print("did press back") 
        navigationController?.popViewController(animated: true)
    }

    @objc private func pressTermsOfUserButton() {
        if let url = URL(string: "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL")
        }
    }

    @objc private func clickSignInWithAppleButton() {

    }
}
