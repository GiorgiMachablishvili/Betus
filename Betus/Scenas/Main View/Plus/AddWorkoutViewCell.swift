//
//  AddWorkoutViewCell.swift
//  Betus
//
//  Created by Gio's Mac on 01.12.24.
//

import UIKit
import SnapKit

protocol AddWorkoutViewCellDelegate: AnyObject {
    func didPressUserInfoButton()
    func didPressRightButton(workoutName: String, workoutImage: UIImage)
    func shouldHideMainBottomButtonView(_ hide: Bool)
    func presentImagePicker(_ picker: UIImagePickerController)
}

class AddWorkoutViewCell: UICollectionViewCell {

    weak var delegate: AddWorkoutViewCellDelegate?

    private var originalViewY: CGFloat = 0
    private var taskViews: [UIView] = []
    private var contentViewBottomConstraint: Constraint?

    lazy var userInfoButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "userProfile"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(pressUserInfoButton), for: .touchUpInside)
        return view
    }()

    lazy var rightButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44 * Constraint.xCoeff, height: 44 * Constraint.yCoeff))
        view.setImage(UIImage(named: "arrow-left-1"), for: .normal)
        view.backgroundColor = UIColor(hexString: "#E5D820")
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.setImage(UIImage(named: "arrow-left-1")?.resize(to: CGSize(width: 16 * Constraint.xCoeff, height: 16 * Constraint.yCoeff)), for: .normal)
        view.addTarget(self, action: #selector(pressRightButton), for: .touchUpInside)
        return view
    }()

    private lazy var userImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.contentMode = .center
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "userImageHolder")
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var nameWorkoutTextfield: UITextField = {
        let view = UITextField(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.font = UIFont.latoRegular(size: 12)
        view.textColor = UIColor(hexString: "FFFFFF")
        view.layer.cornerRadius = 16
        let placeholderText = "  Name Workout"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#FFFFFF").withAlphaComponent(0.4),
            .font: UIFont.latoRegular(size: 14)
        ]
        view.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        return view
    }()

    lazy var easyWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Easy Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(pressEasyLevelWorkoutButton), for: .touchUpInside)
        return view
    }()

    lazy var advancedWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Advanced Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(pressAdvanceLevelWorkoutButton), for: .touchUpInside)
        return view
    }()

    lazy var difficultWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65 * Constraint.xCoeff, height: 41 * Constraint.yCoeff))
        view.setTitle("Difficult Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(pressDifficultLevelWorkoutButton), for: .touchUpInside)
        return view
    }()

    private lazy var descriptionWorkoutTextfield: UITextField = {
        let view = UITextField(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.font = UIFont.latoRegular(size: 12)
        view.layer.cornerRadius = 16
        view.textColor = UIColor(hexString: "FFFFFF")
        let placeholderText = "  Description of the workout"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#FFFFFF").withAlphaComponent(0.4),
            .font: UIFont.latoRegular(size: 14)
        ]
        view.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        return view
    }()

    private lazy var addTaskButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "addTask"), for: .normal)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 26
        view.addTarget(self, action: #selector(pressAddTaskButton), for: .touchUpInside)
        return view
    }()

    private lazy var taskView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.isHidden = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraint()

        easyWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        tapGestureForUserImageView()
        setupTapToDismissKeyboard()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(userInfoButton)
        addSubview(rightButton)
        addSubview(userImageView)
        addSubview(nameWorkoutTextfield)
        addSubview(easyWorkoutLevelsButton)
        addSubview(advancedWorkoutLevelsButton)
        addSubview(difficultWorkoutLevelsButton)
        addSubview(descriptionWorkoutTextfield)
        addSubview(addTaskButton)

    }

    private func setupConstraint() {
        userInfoButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(15 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        rightButton.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(15 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        userImageView.snp.remakeConstraints { make in
            make.top.equalTo(userInfoButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(287 * Constraint.yCoeff)
        }

        nameWorkoutTextfield.snp.remakeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        easyWorkoutLevelsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(advancedWorkoutLevelsButton.snp.centerY)
            make.trailing.equalTo(advancedWorkoutLevelsButton.snp.leading).offset(-8)
            make.width.equalTo(116.6 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        advancedWorkoutLevelsButton.snp.remakeConstraints { make in
            make.top.equalTo(nameWorkoutTextfield.snp.bottom).offset(10 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(116.6 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        difficultWorkoutLevelsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(advancedWorkoutLevelsButton.snp.centerY)
            make.leading.equalTo(advancedWorkoutLevelsButton.snp.trailing).offset(8)
            make.width.equalTo(116.6 * Constraint.xCoeff)
            make.height.equalTo(41 * Constraint.yCoeff)
        }

        descriptionWorkoutTextfield.snp.remakeConstraints { make in
            make.top.equalTo(easyWorkoutLevelsButton.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        addTaskButton.snp.remakeConstraints { make in
            make.top.equalTo(descriptionWorkoutTextfield.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(84 * Constraint.yCoeff)
        }
    }

    func addTask(taskName: String, timer: String, description: String) {
        let taskView = UIView()
        taskView.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        taskView.layer.cornerRadius = 16

        let nameLabel = UILabel()
        nameLabel.text = "Task: \(taskName)"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 14)

        let timerLabel = UILabel()
        timerLabel.text = "Timer: \(timer)"
        timerLabel.textColor = .white
        timerLabel.font = UIFont.systemFont(ofSize: 12)
        

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description: \(description)"
        descriptionLabel.textColor = .white.withAlphaComponent(0.7)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0

        let deleteTaskViewButton = UIButton()
        deleteTaskViewButton.setImage(UIImage(named: "xButton"), for: .normal)
        deleteTaskViewButton.contentMode = .scaleAspectFit
        deleteTaskViewButton.addTarget(self, action: #selector(pressDeleteTaskViewButton(_:)), for: .touchUpInside)

        // Add labels to taskView
        taskView.addSubview(nameLabel)
        taskView.addSubview(timerLabel)
        taskView.addSubview(descriptionLabel)
        taskView.addSubview(deleteTaskViewButton)

        // Constraints for labels inside taskView
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8 * Constraint.yCoeff)
            make.height.equalTo(44 * Constraint.yCoeff)
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(8 * Constraint.xCoeff)
            make.height.equalTo(24 * Constraint.yCoeff)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(4 * Constraint.yCoeff)
            make.leading.trailing.bottom.equalToSuperview().inset(8 * Constraint.xCoeff)
            make.height.equalTo(34 * Constraint.yCoeff)
        }

        deleteTaskViewButton.snp.remakeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalTo(taskView.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.width.height.equalTo(44 * Constraint.xCoeff)
        }

        // Add taskView to cell
        addSubview(taskView)

        // Constraints for taskView
        if let lastTaskView = taskViews.last {
            taskView.snp.makeConstraints { make in
                make.top.equalTo(lastTaskView.snp.bottom).offset(10 * Constraint.yCoeff)
                make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            }
        } else {
            taskView.snp.makeConstraints { make in
                make.top.equalTo(descriptionWorkoutTextfield.snp.bottom).offset(10 * Constraint.yCoeff)
                make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            }
        }
        // Update addTaskButton position
        addTaskButton.snp.remakeConstraints { make in
            make.top.equalTo(taskView.snp.bottom).offset(10 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(84 * Constraint.yCoeff)
        }

        taskViews.append(taskView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func tapGestureForUserImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserImageView))
        userImageView.addGestureRecognizer(tapGesture)
        userImageView.isUserInteractionEnabled = true
    }

    @objc private func didTapUserImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        delegate?.presentImagePicker(imagePicker)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            userImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            userImageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func updateUserImage(_ image: UIImage) {
        userImageView.image = image
    }

    private func addTaskView(taskName: String, timer: String, description: String) {
        let nameLabel = UILabel()
        nameLabel.text = taskName
        nameLabel.textColor = UIColor(hexString: "#FFFFFF")
        nameLabel.font = UIFont.latoRegular(size: 14)

        let timerLabel = UILabel()
        timerLabel.text = timer
        timerLabel.textColor = UIColor(hexString: "#FFFFFF")
        timerLabel.font = UIFont.latoRegular(size: 12)

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.textColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.7)
        descriptionLabel.font = UIFont.latoRegular(size: 12)
        descriptionLabel.numberOfLines = 0

        taskView.addSubview(nameLabel)
        taskView.addSubview(timerLabel)
        taskView.addSubview(descriptionLabel)

        addSubview(taskView)

        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8 * Constraint.yCoeff)
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(8 * Constraint.xCoeff)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(4 * Constraint.yCoeff)
            make.leading.trailing.bottom.equalToSuperview().inset(8 * Constraint.xCoeff)
        }

        if let lastTaskView = taskViews.last {
            taskView.snp.makeConstraints { make in
                make.top.equalTo(lastTaskView.snp.bottom).offset(12 * Constraint.yCoeff)
                make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
                make.height.greaterThanOrEqualTo(60 * Constraint.yCoeff)
            }
        } else {
            taskView.snp.makeConstraints { make in
                make.top.equalTo(addTaskButton.snp.bottom).offset(12 * Constraint.yCoeff)
                make.leading.trailing.equalToSuperview().inset(16 * Constraint.yCoeff)
                make.height.greaterThanOrEqualTo(60 * Constraint.yCoeff)
            }
        }
        taskViews.append(taskView)
    }


    @objc func pressUserInfoButton() {
        delegate?.didPressUserInfoButton()
    }

    @objc func pressRightButton() {
        guard let workoutName = nameWorkoutTextfield.text,
              let workoutImage = userImageView.image,
              !workoutName.isEmpty else {
            print("Error: Missing workout name or image.")
            return
        }
        delegate?.didPressRightButton(workoutName: workoutName, workoutImage: workoutImage)
    }


    @objc func pressEasyLevelWorkoutButton() {
        resetButtonImages()
        easyWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
    }

    @objc func pressAdvanceLevelWorkoutButton() {
        resetButtonImages()
        advancedWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
    }

    @objc func pressDifficultLevelWorkoutButton() {
        resetButtonImages()
        difficultWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
    }

    private func resetButtonImages() {
        easyWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        advancedWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        difficultWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
    }

    @objc func pressAddTaskButton() {
        guard let delegate = delegate as? AddWorkoutViewController else { return }
        delegate.addTaskView.nameWorkoutAddTextfield.text = ""
        delegate.addTaskView.timerAddTextfield.text = ""
        delegate.addTaskView.descriptionWorkoutAddTextfield.text = ""

        // Show the addTaskView and dark overlay
        delegate.darkOverlay.isHidden = false
        delegate.addTaskView.isHidden = false
        delegate.shouldHideMainBottomButtonView(true)

        taskView.isHidden = true
        delegate.addTaskView.configure(taskName: "", timer: "", description: "")
        delegate.shouldHideMainBottomButtonView(true)
    }

    func getSelectedLevel() -> String {
        if easyWorkoutLevelsButton.backgroundColor == UIColor(hexString: "E5D820") {
            return "Easy"
        } else if advancedWorkoutLevelsButton.backgroundColor == UIColor(hexString: "E5D820") {
            return "Advance"
        } else if difficultWorkoutLevelsButton.backgroundColor == UIColor(hexString: "E5D820") {
            return "Difficult"
        } else {
            return "Unknown"
        }
    }

    @objc func pressDeleteTaskViewButton(_ sender: UIButton) {
        guard let taskViewToDelete = sender.superview else {
            print("Error: Unable to find task view for the delete button.")
            return
        }
        if let index = taskViews.firstIndex(of: taskViewToDelete) {
            taskViews.remove(at: index)
            taskViewToDelete.removeFromSuperview()
            print("Task view removed successfully.")
        } else {
            print("Error: Task view not found in the array.")
        }

        updateTaskViewLayout()
    }

    private func updateTaskViewLayout() {
        var previousTaskView: UIView?

        for taskView in taskViews {
            taskView.snp.remakeConstraints { make in
                if let previous = previousTaskView {
                    make.top.equalTo(previous.snp.bottom).offset(10 * Constraint.yCoeff)
                } else {
                    make.top.equalTo(descriptionWorkoutTextfield.snp.bottom).offset(10 * Constraint.yCoeff)
                }
                make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            }
            previousTaskView = taskView
        }

        if let lastTaskView = previousTaskView {
            addTaskButton.snp.remakeConstraints { make in
                make.top.equalTo(lastTaskView.snp.bottom).offset(10 * Constraint.yCoeff)
                make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
                make.height.equalTo(84 * Constraint.yCoeff)
            }
        } else {
            addTaskButton.snp.remakeConstraints { make in
                make.top.equalTo(descriptionWorkoutTextfield.snp.bottom).offset(10 * Constraint.yCoeff)
                make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
                make.height.equalTo(84 * Constraint.yCoeff)
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

extension UIView {
    func firstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            if let responder = subview.firstResponder() {
                return responder
            }
        }
        return nil
    }

    func findFirstResponder() -> UIResponder? {
        for subview in self.subviews {
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

// MARK: - Keyboard Handling
extension AddWorkoutViewCell {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let activeField = findFirstResponder() as? UITextField else { return }

        let keyboardHeight = keyboardFrame.height
        let bottomOfTextField = activeField.convert(activeField.bounds, to: self).maxY
        let visibleAreaHeight = self.bounds.height - keyboardHeight

        if bottomOfTextField > visibleAreaHeight {
            let overlap = bottomOfTextField - visibleAreaHeight
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(translationX: 0, y: -overlap - 50)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }

    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

}
