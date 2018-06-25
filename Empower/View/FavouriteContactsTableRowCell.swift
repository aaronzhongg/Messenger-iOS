//
//  FavouriteContactsTableRowCell.swift
//  Empower
//
//  Created by Aaron Zhong on 21/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit

class FavouriteContactsTableRowCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var contactsCollectionView: UICollectionView!
    var favourites: [Contact]?
    
    let icons = ["teacher", "gentleman", "writer", "worker", "cashier"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contactsCollectionView.dataSource = self
        contactsCollectionView.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contactsCollectionView.register(UINib(nibName: "FavouriteContactCell", bundle: nil), forCellWithReuseIdentifier: "FavouriteContactCell")
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let favourite = favourites?[indexPath.row] else {fatalError()}
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteContactCell", for: indexPath) as! FavouriteContactCell
        
        cell.contactNameLabel.text = favourite.fullName
        cell.contactImageView.image = UIImage(named: icons[indexPath.row])
        
        return cell
    }
    
}

// MARK: - FavouritedContactsDelegate
extension FavouriteContactsTableRowCell: FavouritedContactsDelegate {
    func updateFavouriteContacts(_ favourites: [Contact]) {
        self.favourites = favourites
        contactsCollectionView.reloadData()
    }
}
