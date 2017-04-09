//
//  ExampleCollectionViewController.swift
//  Font
//
//  Created by Adam Yanalunas on 3/31/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Font

protocol FontUpdateable: class {
    func didUpdateFont(using model: FontViewModel)
    func didUpdate(model: FontViewModel, atIndexPath indexPath:IndexPath?)
}

class ExampleCollectionViewController: UICollectionViewController {
    var examples:[FontViewModel] = []
    var families:[FontFamily] = []
    let fonts = FontAutoloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fonts.load()
        
        families = fonts.families
        
        let firstExample = FontViewModel(family: families[3], size: 16, weight: .semibold, isItalic: false, width: .regular)
        let secondExample = FontViewModel(family: families[1], size: 12, weight: .regular, isItalic: true, width: .regular)
        let thirdExample = FontViewModel(family: families[2], size: 20, weight: .thin, isItalic: false, width: .condensed)
        
        examples = [firstExample, secondExample, thirdExample]
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return examples.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExampleCollectionCell.identifier, for: indexPath) as! ExampleCollectionCell
        
        // This probably isn't right
        cell.model = examples[indexPath.item]
        cell.label.font = cell.model?.generateFont()
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ExampleCollectionCell else { return }
        
        edit(model: cell.model, indexPath: indexPath)
    }
}

extension ExampleCollectionViewController {
    @IBAction func handleAddExample(button: UIBarButtonItem) {
        // http://khanlou.com/2015/10/coordinators-redux/
        // http://merowing.info/2016/01/improve-your-ios-architecture-with-flowcontrollers/
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let optionsNav = sb.instantiateViewController(withIdentifier: "OptionsNavigation") as? UINavigationController else { return }
        guard let optionsVC = optionsNav.viewControllers.first as? OptionsController else { return }
        
        optionsVC.families = fonts.families
        optionsVC.delegate = self
        
        present(optionsNav, animated: true, completion: nil)
    }
    
    func edit(model: FontViewModel?, indexPath: IndexPath?) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let optionsNav = sb.instantiateViewController(withIdentifier: "OptionsNavigation") as? UINavigationController else { return }
        guard let optionsVC = optionsNav.viewControllers.first as? OptionsController else { return }
        
        if let model = model {
            optionsVC.model = model
        }
        
        optionsVC.families = fonts.families
        optionsVC.indexPath = indexPath
        optionsVC.delegate = self
        
        present(optionsNav, animated: true, completion: nil)
    }
}

extension ExampleCollectionViewController: FontUpdateable {
    func didUpdateFont(using model:FontViewModel) {
        examples.append(model)
        collectionView?.reloadData()
    }
    
    func didUpdate(model: FontViewModel, atIndexPath indexPath:IndexPath?) {
        if let indexPath = indexPath {
            examples[indexPath.item] = model
            collectionView?.reloadItems(at: [indexPath])
        } else {
            examples.append(model)
            collectionView?.reloadData()
        }
    }
}
