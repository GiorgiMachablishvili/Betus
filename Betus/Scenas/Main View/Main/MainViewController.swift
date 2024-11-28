//
//  MainViewController.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit
import SnapKit

protocol MainBottomButtonViewDelegate: AnyObject {
    func pressHomeButton()
    func pressSearchButton()
    func pressPlusButton()
}

class MainViewController: UIViewController, MainBottomButtonViewDelegate, PlusViewControllerDelegate {
    func shouldHideMainBottomButtonView(_ hide: Bool) {
        mainBottomButtons.isHidden = hide
    }

    private lazy var mainBottomButtons: MainBottomButtonView = {
        let view = MainBottomButtonView()
        view.layer.cornerRadius = 26
        view.delegate = self
        return view
    }()

    private lazy var homeVC = WorkoutViewController()
    private lazy var heartVC = LikedWorkoutViewController()
    private lazy var plusVC: PlusViewController = {
        let view = PlusViewController()
        view.delegate = self
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
        view.backgroundColor = .systemBackground
        self.navigationItem.hidesBackButton = true
        addChildView(homeVC)
        switchToViewController(homeVC)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setup() {
        view.addSubview(mainBottomButtons)
    }

    private func setupConstraints() {
        mainBottomButtons.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(view.snp.bottom).offset(-12)
            make.height.equalTo(108 * Constraint.yCoeff)
        }
    }

    func pressHomeButton() {
        switchToViewController(homeVC)
    }

    func pressSearchButton() {
        switchToViewController(heartVC)
    }

    func pressPlusButton() {
        switchToViewController(plusVC)
    }


    private func switchToViewController(_ newVC: UIViewController) {
        // Remove current child VC
        children.forEach { childVC in
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }

        // Check if the new view controller is AddPhotoFromDeviceViewController
//        if newVC is AddPhotoFromDeviceViewController {
//            mainBottomButtons.isHidden = true
//        } else {
//            mainBottomButtons.isHidden = false
//        }

        // Add new child VC
        addChildView(newVC)
    }

    private func addChildView(_ childVC: UIViewController) {
        addChild(childVC)
        view.insertSubview(childVC.view, belowSubview: mainBottomButtons)
        childVC.view.frame = view.bounds
        childVC.didMove(toParent: self)
    }
}

