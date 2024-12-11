//
//  LikedWorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD

class LikedWorkoutViewController: UIViewController {

    var workoutImage: UIImage?
    var workoutData: [Workouts] = []
    var likedWorkouts: [LikeResponse] = []
    var likeWorkoutCell = LikeWorkoutViewCell()
    var allWorkouts: [Workouts] = []

    private var searchWorkItem: DispatchWorkItem?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 24 * Constraint.xCoeff, height: 287 * Constraint.yCoeff)
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 65 * Constraint.yCoeff)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10 * Constraint.yCoeff, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.isHidden = false
        view.register(LikeWorkoutViewCell.self, forCellWithReuseIdentifier: "LikeWorkoutViewCell")
        return view
    }()
    
    lazy var userInfoButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "userProfile"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(didPressUserInfoButton), for: .touchUpInside)
        return view
    }()

    private lazy var searchButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "searchImage"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.isHidden = false
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "searchImage")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressSearchButton), for: .touchUpInside)
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar(frame: .zero)
        view.layer.cornerRadius = 22
        view.placeholder = "Search"
        view.backgroundColor = .clear
        view.tintColor = UIColor(hexString: "FFFFFF")
        view.isHidden = true
        view.searchBarStyle = .minimal
        view.delegate = self
        if let textField = view.value(forKey: "searchField") as? UITextField {
            let placeholderTextColor = UIColor.lightGray
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor]
            )
            textField.textColor = UIColor(hexString: "FFFFFF")
            if let iconView = textField.leftView as? UIImageView {
                iconView.tintColor = UIColor.lightGray
                iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            }
        }
        return view
    }()

    private lazy var infoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.text = "You don't have any selected workouts yet"
        view.textColor = UIColor(hexString: "FFFFFF")
        view.font = UIFont.latoBold(size: 16)
        view.numberOfLines = 2
        view.isHidden = true
        return view
    }()

    private lazy var forOrderingStoreLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.text = "In order for us to store your favourites you must be logged in."
        view.textColor = UIColor(hexString: "FFFFFF")
        view.font = UIFont.latoBold(size: 16)
        view.numberOfLines = 2
        view.isHidden = true
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
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()

        hiddenOrUnhidden()

        fetchLikedWorkouts()
    }

    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(userInfoButton)
        view.addSubview(searchButton)
        view.addSubview(searchBar)
        view.addSubview(infoLabel)
        view.addSubview(forOrderingStoreLabel)
        view.addSubview(signInWithAppleButton)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.top.equalTo(view.snp.top).offset(10 * Constraint.yCoeff)
            make.bottom.equalToSuperview()
        }

        userInfoButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(12 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        searchButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60 * Constraint.yCoeff)
            make.trailing.equalTo(view.snp.trailing).offset(-12 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        searchBar.snp.remakeConstraints { make in
            make.centerY.equalTo(userInfoButton.snp.centerY)
            make.leading.equalTo(userInfoButton.snp.trailing).offset(4 * Constraint.xCoeff)
            make.width.equalTo(318 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        infoLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(230 * Constraint.xCoeff)
        }

        forOrderingStoreLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(367 * Constraint.yCoeff)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(366 * Constraint.xCoeff)
        }

        signInWithAppleButton.snp.remakeConstraints { make in
            make.top.equalTo(forOrderingStoreLabel.snp.bottom).offset(16 * Constraint.yCoeff)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(366 * Constraint.xCoeff)
            make.height.equalTo(56 * Constraint.yCoeff)
        }
    }

    func hiddenOrUnhidden() {
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestUser")
        collectionView.isHidden = isGuestUser
        infoLabel.isHidden = !isGuestUser
        forOrderingStoreLabel.isHidden = !isGuestUser
        signInWithAppleButton.isHidden = !isGuestUser
    }

    private func fetchLikedWorkouts() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") else { return }
        let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/workouts/user/\(userId)"

        NetworkManager.shared.post(url: url, parameters: nil, headers: nil) { (result: Result<[LikeResponse]>) in
                switch result {
                case .success(let likedWorkouts):
                    let likedWorkouts = likedWorkouts.filter { $0.isSelected == true }
                DispatchQueue.main.async {
                    if likedWorkouts.isEmpty {
                        self.likeWorkoutCell.workoutInfoView.isHidden = true
                        self.likeWorkoutCell.likeViewButton.isHidden = true
                        self.likeWorkoutCell.workoutInfoView.isHidden = true
                        self.infoLabel.isHidden = false
                    } else {
                        self.likeWorkoutCell.workoutInfoView.isHidden = false
                        self.likeWorkoutCell.likeViewButton.isHidden = false
                        self.likeWorkoutCell.workoutInfoView.isHidden = false
                        self.infoLabel.isHidden = true
                    }
                    self.likedWorkouts = likedWorkouts
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching liked workouts: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.infoLabel.isHidden = false
                    self.collectionView.isHidden = true
                }
            }
        }
    }

    @objc private func clickSignInWithAppleButton() {
        // Simulating tokens for testing
        let mockPushToken = "mockPushTokenTest2"
        let mockAppleToken = "mockAppleTokenTest2"

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
            url: "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/users/",
            parameters: parameters,
            headers: nil
        ) { [weak self] (result: Result<UserInfo>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                NetworkManager.shared.showProgressHud(false, animated: false)
                UserDefaults.standard.setValue(false, forKey: "isGuestUser")
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
                    self.showAlert(title: "Error", description: error.localizedDescription)
                }
                print("Error: \(error)")
            }
        }
        let mainVC = MainViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }

    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc func didPressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }

    @objc func pressSearchButton() {
        searchButton.isHidden = true
        searchBar.isHidden = false
    }
}

extension LikedWorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        likedWorkouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LikeWorkoutViewCell.self), for: indexPath) as? LikeWorkoutViewCell else {
            return UICollectionViewCell()
        }
        let workout = workoutData[indexPath.row]
        cell.configure(with: workout)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hardWorkoutVC = HardWorkoutViewController()
        navigationController?.pushViewController(hardWorkoutVC, animated: true)
    }
}

extension LikedWorkoutViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel() // Cancel any pending search operations
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if searchText.isEmpty {
                // Display all liked workouts when search text is empty
                self.workoutData = self.workoutData.filter { $0.isSelected }
            } else {
                // Filter liked workouts by search text
                self.workoutData = self.workoutData.filter { workout in
                    workout.details.lowercased().contains(searchText.lowercased())
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem) // Add a delay for better user experience
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.resignFirstResponder() // Dismiss the keyboard
            allWorkouts = workoutData.filter { $0.isSelected } // Reset to all liked workouts
            collectionView.reloadData()
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder() // Dismiss the keyboard
        }
    }
extension LikedWorkoutViewController: ASAuthorizationControllerDelegate /*ASAuthorizationControllerPresentationContextProviding*/ {
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


