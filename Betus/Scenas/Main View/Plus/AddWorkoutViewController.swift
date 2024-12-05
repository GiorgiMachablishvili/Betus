//
//  AddWorkoutViewController.swift
//  Betus
//
//  Created by Gio's Mac on 01.12.24.
//

import UIKit
import SnapKit
import Alamofire

protocol AddWorkoutViewControllerDelegate: AnyObject {
    func shouldHideMainBottomButtonView(_ hide: Bool)
}

class AddWorkoutViewController: UIViewController {

    weak var delegate: AddWorkoutViewControllerDelegate?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.itemSize = CGSize(width: 390, height: 844)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(hexString: "#101538")
        view.register(AddWorkoutViewCell.self, forCellWithReuseIdentifier: "AddWorkoutViewCell")
        return view
    }()

    lazy var darkOverlay: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()

    lazy var addTaskView: AddTaskView = {
        let view = AddTaskView()
        view.layer.cornerRadius = 32
        view.isHidden = true
        view.delegate = self
        return view
    }()


    private lazy var taskView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraint()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupTapToDismissKeyboard()

    }

    func setup() {
        view.addSubview(collectionView)
        view.addSubview(darkOverlay)
        view.addSubview(addTaskView)
        view.addSubview(taskView)
    }

    func setupConstraint() {
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        darkOverlay.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        addTaskView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(343 * Constraint.yCoeff)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func pressDeleteTaskViewButton() {

    }

}

extension AddWorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddWorkoutViewCell", for: indexPath) as? AddWorkoutViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        return cell
    }
}

extension AddWorkoutViewController: AddWorkoutViewCellDelegate {
    func didPressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }

    func didPressRightButton(workoutName: String, workoutImage: UIImage) {
        guard let workoutImageData = workoutImage.jpegData(compressionQuality: 0.8) else { return }

        let id = UserDefaults.standard.value(forKey: "userId")
        let url = "https://betus-orange-nika-46706b42b39b.herokuapp.com/api/v1/workouts/"

        guard let visibleCell = collectionView.visibleCells.first as? AddWorkoutViewCell else { return }
        let selectedLevel = visibleCell.getSelectedLevel()

        guard let timerValue = addTaskView.timerAddTextfield.text, !timerValue.isEmpty else {
              showAlert(title: "Error", description: "Please provide a valid timer value.")
              return
          }
        let timeInSeconds = convertTimerToSeconds(timerValue)

        let parameters: [String: Any] = [
            "task_count": 0,
            "time": timeInSeconds,
            "level": selectedLevel,
            "completers": [],
            "details": workoutName,
            "user_id": id ?? "",
            "image": workoutImageData.base64EncodedString()
        ]
        NetworkManager.shared.showProgressHud(true, animated: true)

        // Make PUT request
        NetworkManager.shared.post(url: url, parameters: parameters, headers: nil) { (result: Result<Workouts>) in
            NetworkManager.shared.showProgressHud(false, animated: false)
            switch result {
            case .success(let workout):
                let mainViewController = MainViewController()
                self.navigationController?.pushViewController(mainViewController, animated: true)
                print("Workout saved successfully: \(workout)")
            case .failure(let error):
                print("Error saving workout: \(error.localizedDescription)")
            }
        }
    }
    // Helper: Show an alert to the user
    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func convertTimerToSeconds(_ timerString: String) -> Int {
        let components = timerString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 3 else { return 0 }
        let hours = components[0]
        let minutes = components[1]
        let seconds = components[2]
        return (hours * 3600) + (minutes * 60) + seconds
    }


    func shouldHideMainBottomButtonView(_ hide: Bool) {
        delegate?.shouldHideMainBottomButtonView(hide)
    }
}

extension AddWorkoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(_ picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            updateVisibleCell(with: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            updateVisibleCell(with: originalImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    private func updateVisibleCell(with image: UIImage) {
        guard let visibleCell = collectionView.visibleCells.first as? AddWorkoutViewCell else { return }
        visibleCell.updateUserImage(image)
    }
}

extension AddWorkoutViewController: AddTaskViewDelegate {
    func didPressAddButton(taskName: String, timer: String, description: String) {
        darkOverlay.isHidden = true
        addTaskView.isHidden = true
        taskView.isHidden = false

        if let visibleCell = collectionView.visibleCells.first as? AddWorkoutViewCell {
            visibleCell.addTask(taskName: taskName, timer: timer, description: description)
        }

        let taskLabel = UILabel()
        taskLabel.text = "Task: \(taskName)\nTimer: \(timer)\nDescription: \(description)"
        taskLabel.textColor = UIColor.white
        taskLabel.numberOfLines = 0
        taskLabel.textAlignment = .left
        taskView.addSubview(taskLabel)

        taskLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8 * Constraint.yCoeff)
        }

        delegate?.shouldHideMainBottomButtonView(false)
    }

    func didPressCancelButton() {
        darkOverlay.isHidden = true
        addTaskView.isHidden = true
        taskView.isHidden = false
        delegate?.shouldHideMainBottomButtonView(false)
    }
}

// MARK: - Keyboard Handling
extension AddWorkoutViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let activeField = findFirstResponder() as? UIView else { return }

        let keyboardHeight = keyboardFrame.height
        let bottomOfTextField = activeField.convert(activeField.bounds, to: view).maxY
        let visibleAreaHeight = view.bounds.height - keyboardHeight

        if bottomOfTextField > visibleAreaHeight {
            let overlap = bottomOfTextField - visibleAreaHeight
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -overlap - 20)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }

    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func findFirstResponder() -> UIResponder? {
        for subview in view.subviews {
            if subview.isFirstResponder {
                return subview
            }
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
