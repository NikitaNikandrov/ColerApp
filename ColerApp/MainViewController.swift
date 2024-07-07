//
//  ViewController.swift
//  ColerApp
//
//  Created by Nikita Nikandrov on 07.07.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @objc private func heartButtonTapped() {
        print("Heart button tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupFindButton()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Coler App"
        
        navigationController?.navigationBar.tintColor = .white
        
        let heartImage = UIImage(systemName: "heart.fill")
        let rightBarButtonItem = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: #selector(heartButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        setStatusBarBackgroundColor(color: .lightGray)
    }
    
    private func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame else { return }
        
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = color
        view.addSubview(statusBarView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupFindButton() {
        let findButton = FindButton()
        findButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(findButton)
        
        NSLayoutConstraint.activate([
            findButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            findButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            findButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            findButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

