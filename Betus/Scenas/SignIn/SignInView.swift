//
//  ViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

//TODO: registration
//TODO: create user
//TODO: post information in back from AddWorkoutViewController
//TODO: when post info from AddWorkoutViewController how should be struct of Model
//TODO: fetch info from back
//TODO: how make number of likes likeViewButton title in WorkoutInfoCell 
//TODO: post like info


import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD

class SignInView: UIViewController {

    private lazy var singInLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Sign IN"
        view.textColor = UIColor.init(hexString: "FFFFFF")
        view.font = UIFont.latoBold(size: 24)
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
        view.imageEdgeInsets = UIEdgeInsets(top: 16 * Constraint.yCoeff, left: -5 * Constraint.xCoeff, bottom: 16 * Constraint.yCoeff, right: 0)
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
        view.backgroundColor = UIColor.init(hexString: "101538")
        view.applyGradientBackground()
    }

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
            make.bottom.equalTo(view.snp.bottom).offset(-127 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(37 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }

        logInAsGuestButton.snp.remakeConstraints { make in
            make.top.equalTo(signInWithAppleButton.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(37 * Constraint.xCoeff)
            make.height.equalTo(59 * Constraint.yCoeff)
        }
    }
    
    // MARK: - Button Actions
    @objc func clickLogInAsGuestButton() {
        let mainVC = MainViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }

    @objc func clickSignInWithAppleButton() {
        // Simulating tokens for testing
        let mockPushToken = "mockPushTokenTest1"
        let mockAppleToken = "mockAppleTokenTest1"

        // Store mock tokens in UserDefaults
        UserDefaults.standard.setValue(mockPushToken, forKey: "PushToken")
        UserDefaults.standard.setValue(mockAppleToken, forKey: "AccountCredential")

        // Call createUser to simulate user creation
        createUser()

//        let authorizationProvider = ASAuthorizationAppleIDProvider()
//        let request = authorizationProvider.createRequest()
//        request.requestedScopes = [.email, .fullName]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.performRequests()
    }

    private func createUser() {
        NetworkManager.shared.showProgressHud(true, animated: true)

        let pushToken = UserDefaults.standard.string(forKey: "PushToken") ?? ""
        let appleToken = UserDefaults.standard.string(forKey: "AccountCredential") ?? ""

        // Prepare parameters
        let parameters: [String: Any] = [
            "push_token": pushToken,
            "auth_token": appleToken
        ]

        // Make the network request
        NetworkManager.shared.post(
            url: "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/users",
            parameters: parameters,
            headers: nil
        ) { [weak self] (result: Result<UserInfo>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                NetworkManager.shared.showProgressHud(false, animated: false)
            }

            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    print("User created: \(userInfo)")
                    UserDefaults.standard.setValue(userInfo.id, forKey: "userId")
                    print("Received User ID: \(userInfo.id)")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    //Show error message
                    self.showAlert(title: "Error", description: error.localizedDescription)
                }
                print("Error: \(error)")
            }
        }
//        let mainVC = MainViewController()
//        navigationController?.pushViewController(mainVC, animated: true)
    }

    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SignInView: ASAuthorizationControllerDelegate /*ASAuthorizationControllerPresentationContextProviding*/ {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

        UserDefaults.standard.setValue(credential.user, forKey: "AccountCredential")
//        createUser()
    }

    //    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    //        print("Authorization failed: \(error.localizedDescription)")
    //        showAlert(title: "Sign In Failed", description: error.localizedDescription)
    //    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
        if nsError.domain == ASAuthorizationError.errorDomain {
            switch nsError.code {
            case ASAuthorizationError.canceled.rawValue:
                print("User canceled the Apple Sign-In process.")
                // Optionally show a message or simply return
                return
            case ASAuthorizationError.failed.rawValue:
                print("Sign-In failed.")
                showAlert(title: "Sign In Failed", description: "Something went wrong. Please try again.")
            case ASAuthorizationError.invalidResponse.rawValue:
                print("Invalid response from Apple Sign-In.")
                showAlert(title: "Invalid Response", description: "We couldn't authenticate you. Please try again.")
            case ASAuthorizationError.notHandled.rawValue:
                print("Apple Sign-In not handled.")
                showAlert(title: "Not Handled", description: "The request wasn't handled. Please try again.")
            case ASAuthorizationError.unknown.rawValue:
                print("An unknown error occurred.")
                showAlert(title: "Unknown Error", description: "An unknown error occurred. Please try again.")
            default:
                break
            }
        } else {
            print("Authorization failed with error: \(error.localizedDescription)")
            showAlert(title: "Sign In Failed", description: error.localizedDescription)
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

