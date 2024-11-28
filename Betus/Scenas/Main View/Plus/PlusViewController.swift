//
//  PlusViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

protocol PlusViewControllerDelegate: AnyObject {
    func shouldHideMainBottomButtonView(_ hide: Bool)
}

class PlusViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var delegate: PlusViewControllerDelegate?

    private var originalViewY: CGFloat = 0

    private var taskViews: [UIView] = []

    //TODO: view should scrolling but when I make it scrolling I cant press textFields and buttons.
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    lazy var userInfoButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "userProfile"), for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "userProfile")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        view.addTarget(self, action: #selector(pressUserInfoButton), for: .touchUpInside)
        return view
    }()

    lazy var rightButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "arrow-left-1"), for: .normal)
        view.backgroundColor = UIColor(hexString: "#E5D820")
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "arrow-left-1")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
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

    private lazy var easyWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 41))
        view.setTitle("Easy Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressEasyLevelWorkoutButton), for: .touchUpInside)
        return view
    }()

    private lazy var advancedWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 41))
        view.setTitle("Advanced Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressAdvanceLevelWorkoutButton), for: .touchUpInside)
        return view
    }()

    private lazy var difficultWorkoutLevelsButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 41))
        view.setTitle("Difficult Level", for: .normal)
        view.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        view.layer.cornerRadius = 16
        view.titleLabel?.font = UIFont.latoRegular(size: 14)
        view.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
        view.clipsToBounds = true
        view.imageView?.contentMode = .scaleAspectFit
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

    private lazy var darkOverlay: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()

    private lazy var addTaskView: AddTaskView = {
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
        view.isHidden = false
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#101538")
        view.applyGradientBackground()
        setup()
        setupConstraints()
        easyWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")

        originalViewY = view.frame.origin.y

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupTapToDismissKeyboard()
        tapGestureForUserImageView()
    }

    deinit {
        // Remove observers to prevent memory leaks
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let activeField = view.firstResponder() as? UITextField else { return }

        // Calculate the visible area
        let keyboardHeight = keyboardFrame.height
        let bottomOfTextField = activeField.convert(activeField.bounds, to: view).maxY
        let visibleAreaHeight = view.bounds.height - keyboardHeight

        if bottomOfTextField > visibleAreaHeight {
            // Move the view up by the overlapping amount
            let overlap = bottomOfTextField - visibleAreaHeight
            view.frame.origin.y = originalViewY - overlap - 70 // Add some padding
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = originalViewY
    }

    private func setup() {
        view.addSubview(userInfoButton)
        view.addSubview(rightButton)
        view.addSubview(userImageView)
        view.addSubview(nameWorkoutTextfield)
        view.addSubview(easyWorkoutLevelsButton)
        view.addSubview(advancedWorkoutLevelsButton)
        view.addSubview(difficultWorkoutLevelsButton)
        view.addSubview(descriptionWorkoutTextfield)
        view.addSubview(addTaskButton)
        view.addSubview(darkOverlay)
        view.addSubview(addTaskView)
    }

//    private func setup() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//    
//        contentView.addSubview(userInfoButton)
//        contentView.addSubview(leftButton)
//        contentView.addSubview(userImageView)
//        contentView.addSubview(nameWorkoutTextfield)
//        contentView.addSubview(easyWorkoutLevelsButton)
//        contentView.addSubview(advancedWorkoutLevelsButton)
//        contentView.addSubview(difficultWorkoutLevelsButton)
//        contentView.addSubview(descriptionWorkoutTextfield)
//        contentView.addSubview(addTaskButton)
//        contentView.addSubview(darkOverlay)
//        contentView.addSubview(addTTaskView)
//    }

//    private func setupConstraints() {
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView)
//            make.width.equalTo(scrollView)
//        }
//    
//        userInfoButton.snp.remakeConstraints { make in
//            make.top.equalTo(contentView.snp.top).offset(60)
//            make.leading.equalTo(contentView.snp.leading).offset(12)
//            make.width.height.equalTo(44)
//        }
//    
//        leftButton.snp.remakeConstraints { make in
//            make.top.equalTo(contentView.snp.top).offset(60)
//            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
//            make.width.height.equalTo(44)
//        }
//    
//        userImageView.snp.remakeConstraints { make in
//            make.top.equalTo(userInfoButton.snp.bottom).offset(10)
//            make.leading.trailing.equalTo(contentView).inset(12)
//            make.height.equalTo(287)
//        }
//    
//        nameWorkoutTextfield.snp.remakeConstraints { make in
//            make.top.equalTo(userImageView.snp.bottom).offset(10)
//            make.leading.trailing.equalTo(contentView).inset(12)
//            make.height.equalTo(44)
//        }
//    
//        easyWorkoutLevelsButton.snp.remakeConstraints { make in
//            make.top.equalTo(nameWorkoutTextfield.snp.bottom).offset(10)
//            make.trailing.equalTo(advancedWorkoutLevelsButton.snp.leading).offset(-8)
//            make.width.equalTo(116.6)
//            make.height.equalTo(41)
//        }
//    
//        advancedWorkoutLevelsButton.snp.remakeConstraints { make in
//            make.top.equalTo(nameWorkoutTextfield.snp.bottom).offset(10)
//            make.centerX.equalTo(contentView.snp.centerX)
//            make.width.equalTo(116.6)
//            make.height.equalTo(41)
//        }
//    
//        difficultWorkoutLevelsButton.snp.remakeConstraints { make in
//            make.top.equalTo(nameWorkoutTextfield.snp.bottom).offset(10)
//            make.leading.equalTo(advancedWorkoutLevelsButton.snp.trailing).offset(8)
//            make.width.equalTo(116.6)
//            make.height.equalTo(41)
//        }
//    
//        descriptionWorkoutTextfield.snp.remakeConstraints { make in
//            make.top.equalTo(easyWorkoutLevelsButton.snp.bottom).offset(10)
//            make.leading.trailing.equalTo(contentView).inset(12)
//            make.height.equalTo(44)
//        }
//    
//        addTaskButton.snp.remakeConstraints { make in
//            make.top.equalTo(descriptionWorkoutTextfield.snp.bottom).offset(10)
//            make.leading.trailing.equalTo(contentView).inset(12)
//            make.height.equalTo(84)
//        }
//    
//        darkOverlay.snp.remakeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    
//        addTTaskView.snp.remakeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(343)
//        }
//    }

    private func setupConstraints() {
        userInfoButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.width.height.equalTo(44)
        }

        rightButton.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(60)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.width.height.equalTo(44)
        }

        userImageView.snp.remakeConstraints { make in
            make.top.equalTo(userInfoButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(287)
        }

        nameWorkoutTextfield.snp.remakeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }

        easyWorkoutLevelsButton.snp.remakeConstraints { make in
            make.top.equalTo(nameWorkoutTextfield.snp.bottom).offset(10)
            make.trailing.equalTo(advancedWorkoutLevelsButton.snp.leading).offset(-8)
            make.width.equalTo(116.6)
            make.height.equalTo(41)
        }

        advancedWorkoutLevelsButton.snp.remakeConstraints { make in
            make.top.equalTo(nameWorkoutTextfield.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(116.6)
            make.height.equalTo(41)
        }

        difficultWorkoutLevelsButton.snp.remakeConstraints { make in
            make.top.equalTo(nameWorkoutTextfield.snp.bottom).offset(10)
            make.leading.equalTo(advancedWorkoutLevelsButton.snp.trailing).offset(8)
            make.width.equalTo(116.6)
            make.height.equalTo(41)
        }

        descriptionWorkoutTextfield.snp.remakeConstraints { make in
            make.top.equalTo(easyWorkoutLevelsButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }

        addTaskButton.snp.remakeConstraints { make in
            make.top.equalTo(descriptionWorkoutTextfield.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(84)
        }

        darkOverlay.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        addTaskView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(343)
        }
    }

    private func tapGestureForUserImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserImageView))
        userImageView.addGestureRecognizer(tapGesture)
        userImageView.isUserInteractionEnabled = true
    }

    @objc private func didTapUserImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
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

    //TODO: Make taskView Constraints every taskView should be up to addTaskButton
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

        view.addSubview(taskView)

        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }

        if let lastTaskView = taskViews.last {
            taskView.snp.makeConstraints { make in
                make.top.equalTo(lastTaskView.snp.bottom).offset(12)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.greaterThanOrEqualTo(60)
            }
        } else {
            taskView.snp.makeConstraints { make in
                make.top.equalTo(addTaskButton.snp.bottom).offset(12)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.greaterThanOrEqualTo(60)
            }
        }

        taskViews.append(taskView)
    }

//    private func addTaskView(taskName: String, timer: String, description: String) {
//        let taskView = UIView()
//        taskView.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
//        taskView.layer.cornerRadius = 16
//    
//        let nameLabel = UILabel()
//        nameLabel.text = taskName
//        nameLabel.textColor = UIColor(hexString: "#FFFFFF")
//        nameLabel.font = UIFont.latoRegular(size: 14)
//    
//        let timerLabel = UILabel()
//        timerLabel.text = timer
//        timerLabel.textColor = UIColor(hexString: "#FFFFFF")
//        timerLabel.font = UIFont.latoRegular(size: 12)
//    
//        let descriptionLabel = UILabel()
//        descriptionLabel.text = description
//        descriptionLabel.textColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.7)
//        descriptionLabel.font = UIFont.latoRegular(size: 12)
//        descriptionLabel.numberOfLines = 0
//    
//        taskView.addSubview(nameLabel)
//        taskView.addSubview(timerLabel)
//        taskView.addSubview(descriptionLabel)
//    
//        // Layout using SnapKit
//        nameLabel.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview().inset(8)
//        }
//    
//        timerLabel.snp.makeConstraints { make in
//            make.top.equalTo(nameLabel.snp.bottom).offset(4)
//            make.leading.trailing.equalToSuperview().inset(8)
//        }
//    
//        descriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(timerLabel.snp.bottom).offset(4)
//            make.leading.trailing.bottom.equalToSuperview().inset(8)
//        }
//    
//        contentView.addSubview(taskView)
//    
//        // Stack task views vertically
//        if let lastTaskView = taskViews.last {
//            taskView.snp.makeConstraints { make in
//                make.top.equalTo(lastTaskView.snp.bottom).offset(12)
//                make.leading.trailing.equalTo(contentView).inset(16)
//                make.height.greaterThanOrEqualTo(60)
//            }
//        } else {
//            taskView.snp.makeConstraints { make in
//                make.top.equalTo(addTaskButton.snp.bottom).offset(12)
//                make.leading.trailing.equalTo(contentView).inset(16)
//                make.height.greaterThanOrEqualTo(60)
//            }
//        }
//    
//        taskViews.append(taskView)
//    
//        taskView.snp.makeConstraints { make in
//            make.bottom.equalTo(contentView.snp.bottom)
//        }
//    }


    @objc private func pressUserInfoButton() {
        let profileView = ProfileViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }

    @objc private func pressEasyLevelWorkoutButton() {
        resetButtonImages()
        easyWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
    }

    @objc private func pressAdvanceLevelWorkoutButton() {
        print("did press advance level")
        resetButtonImages()
        advancedWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
    }

    @objc private func pressDifficultLevelWorkoutButton() {
        resetButtonImages()
        difficultWorkoutLevelsButton.backgroundColor = UIColor(hexString: "E5D820")
    }

    private func resetButtonImages() {
        easyWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        advancedWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
        difficultWorkoutLevelsButton.backgroundColor = UIColor.clearBlur(withAlpha: 0.1)
    }

    @objc private func pressAddTaskButton() {
        addTaskView.nameWorkoutAddTextfield.text = ""
        addTaskView.timerAddTextfield.text = ""
        addTaskView.descriptionWorkoutAddTextfield.text = ""

        darkOverlay.isHidden = false
        addTaskView.isHidden = false
        taskView.isHidden = true

        delegate?.shouldHideMainBottomButtonView(true)
    }

    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func pressRightButton() {
        let mainViewController = MainViewController()
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}

extension PlusViewController: AddTaskViewDelegate {
    func didPressAddButton(taskName: String, timer: String, description: String) {
        darkOverlay.isHidden = true
        addTaskView.isHidden = true
        taskView.isHidden = false


        delegate?.shouldHideMainBottomButtonView(false)
        addTaskView(taskName: taskName, timer: timer, description: description)
    }
    
    func didPressCancelButton() {
        darkOverlay.isHidden = true
        addTaskView.isHidden = true
        taskView.isHidden = false
        delegate?.shouldHideMainBottomButtonView(false)
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
}

