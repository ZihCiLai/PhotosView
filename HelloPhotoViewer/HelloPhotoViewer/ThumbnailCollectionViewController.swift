//
//  ThumbnailCollectionViewController.swift
//  HelloPhotoViewer
//
//  Created by Lai Zih Ci on 2016/12/21.
//  Copyright © 2016年 ZihCi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ThumbnailCollectionViewController: UICollectionViewController {

    @IBOutlet var collection: UICollectionView!
    @IBAction func reLoadData(_ sender: UIBarButtonItem) {
        collection.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showDetail" else {
            return
        }
        
        // Get the seleted indexPath
        let selectedItems = self.collectionView?.indexPathsForSelectedItems
        let indexPath = selectedItems?.first
        
        // Find out corect view controller.
        let navigationcotnroller = segue.destination as? UINavigationController
        let viewControll = navigationcotnroller?.topViewController as? DetailViewController
        if let index = indexPath {
            viewControll?.targetIndex = index.row
        }
        
        // For SplitViewController Support
        viewControll?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        viewControll?.navigationItem.leftItemsSupplementBackButton = true
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return DataManager.shared.totalCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ThumbnailCollectionViewCell
    
        let dataManager = DataManager.shared
        
        cell.fileNameLabel.text = dataManager.getFileName(at: indexPath.row)
        cell.photoImageView.image = dataManager.getImage(at: indexPath.row)
        
        return cell
    }

}
