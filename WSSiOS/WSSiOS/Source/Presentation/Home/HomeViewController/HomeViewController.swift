//
//  HomeViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - UI Components
    
    private let rootView = HomeView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .White
        setCollectionViewConfig()
    }
    
    private func setCollectionViewConfig() {
        rootView.sosopickView.sosoPickCollectionView.register(HomeSosoPickCollectionViewCell.self, forCellWithReuseIdentifier: HomeSosoPickCollectionViewCell.identifier)
        rootView.sosopickView.sosoPickCollectionView.dataSource = self
        rootView.sosopickView.sosoPickCollectionView.delegate = self
    }
}

//MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate {}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSosoPickCollectionViewCell.identifier, for: indexPath) as? HomeSosoPickCollectionViewCell else { return UICollectionViewCell()}

        return item
    }
}
