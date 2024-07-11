//
//  ViewController.swift
//  ColerApp
//
//  Created by Nikita Nikandrov on 07.07.2024.
//

import UIKit

class MainViewController: UIViewController {
    let findButton = FindButton()
    
    var cameraView: CameraViewProtocol?
    var cameraPresenter: CameraViewPresenterProtocol?
    
    @objc private func heartButtonTapped() {
        print("Heart button tapped")
    }
    
    @objc private func findButtonTapped() {
        print("Find color button tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupFindButton()
        setupCameraView()
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
        findButton.translatesAutoresizingMaskIntoConstraints = false
        findButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
        view.addSubview(findButton)
        
        NSLayoutConstraint.activate([
            findButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            findButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            findButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            findButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCameraView() {
        let cameraViewInstance = CameraView(frame: view.bounds)
        
        guard let cameraViewAsUIView = cameraViewInstance as? UIView else { return }
        
        let cameraPresenterInstance = CameraViewPresenter(view: cameraViewInstance)
        
        cameraViewInstance.presenter = cameraPresenterInstance
        
        cameraViewAsUIView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cameraViewAsUIView)
        
        NSLayoutConstraint.activate([
            cameraViewAsUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cameraViewAsUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cameraViewAsUIView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cameraViewAsUIView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        self.cameraView = cameraViewInstance
        self.cameraPresenter = cameraPresenterInstance
    }
}

