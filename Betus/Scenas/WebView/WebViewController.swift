//
//  WebViewController.swift
//  Betus
//
//  Created by Gio's Mac on 13.12.24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private let webView = WKWebView()
    private let urlString: String

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func loadURL() {
        guard let url = URL(string: urlString) else {
            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
