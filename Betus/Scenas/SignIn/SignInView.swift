//
//  ViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit
import AuthenticationServices

class SignInView: UIViewController {

    private lazy var singInLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Sign IN"
        view.textColor = UIColor.init(hexString: "FFFFFF")
        view.font = UIFont.latoRegular(size: 24)
        view.textAlignment = .center
        return view
    }()

    private lazy var singInInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Log in with your Apple ID to swiftly and safely access all the features of our game!"
        view.textColor = UIColor.init(hexString: "FFFFFF").withAlphaComponent(0.4)
        view.font = UIFont.latoBold(size: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
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
        return view
    }()


    private lazy var logInAsGuestButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("log in as guest", for: .normal)
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.borderColor = UIColor.init(hexString: "FFFFFF").withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(clickLogInAsGuestButton), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupConstraints()
//        setupGradientBackground()
        view.backgroundColor = UIColor.init(hexString: "101538")
        view.applyGradientBackground()
    }


//    private func setupGradientBackground() {
//        let gradientView = UIView.gradientViewWithCenterYellow(
//            size: CGSize(width: view.bounds.width, height: view.bounds.height)
//        )
//        gradientView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(gradientView)
//        view.sendSubviewToBack(gradientView)
//
//        gradientView.snp.makeConstraints { make in
////            make.top.equalTo(view.snp.top).offset(-204)
////            make.leading.equalTo(view.snp.leading).offset(-210)
////            make.height.equalTo(258)
////            make.width.equalTo(404)
//            make.edges.equalToSuperview()
//        }
//    }

    private func setup() {
        view.addSubview(singInLabel)
        view.addSubview(singInInfoLabel)
        view.addSubview(signInWithAppleButton)
        view.addSubview(logInAsGuestButton)
    }

    private func setupConstraints() {
        singInLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(384 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(29 * Constraint.yCoeff)
        }

        singInInfoLabel.snp.remakeConstraints { make in
            make.top.equalTo(singInLabel.snp.bottom).offset(12 * Constraint.xCoeff)
            make.leading.trailing.equalToSuperview().inset(47 * Constraint.yCoeff)
        }

        signInWithAppleButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-127)
            make.leading.trailing.equalToSuperview().inset(37)
            make.height.equalTo(59)
        }

        logInAsGuestButton.snp.remakeConstraints { make in
            make.top.equalTo(signInWithAppleButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(37)
            make.height.equalTo(59)
        }
    }

    //TODO: how to make registration with apple account
    //TODO: data for backend
    @objc func clickSignInWithAppleButton() {
                let mainVC = MainViewController()
                navigationController?.pushViewController(mainVC, animated: true)

//        startSignInWithAppleFlow()
    }

    @objc func clickLogInAsGuestButton() {

    }

//    private func startSignInWithAppleFlow() {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
}

//extension SignInView: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return view.window!
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            // Extract user details
//            let firstName = fullName?.givenName ?? ""
//            let lastName = fullName?.familyName ?? ""
//
//            print("User Identifier: \(userIdentifier)")
//            print("Full Name: \(firstName) \(lastName)")
//            print("Email: \(email ?? "No email provided")")
//
//            // Save user details to Firebase or your backend
//            saveUserToBackend(userId: userIdentifier, firstName: firstName, lastName: lastName, email: email)
//
//            // Navigate to the next screen
//            let mainVC = MainViewController()
//            navigationController?.pushViewController(mainVC, animated: true)
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Sign in with Apple failed: \(error.localizedDescription)")
//
//        // Display an alert
//        let alert = UIAlertController(title: "Sign In Failed", message: "Unable to complete sign in with Apple. Please try again.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//}
