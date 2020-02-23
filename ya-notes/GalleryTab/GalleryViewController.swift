//
//  GalleryCollctionViewController.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/19/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var images: [UIImage] = []
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem! {
        didSet {
            addBarButton.target = self
            addBarButton.action = #selector(addPhotoAlert)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil),
                                       forCellWithReuseIdentifier: "imageCell")
    }
    
}

extension GalleryViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc private func addPhotoAlert() {
        let alert = UIAlertController(title: nil, message: "Add photo", preferredStyle: .actionSheet)
        let galleryButton = UIAlertAction(title: "Camera roll", style: .default, handler: { [weak self] action in
            self?.addPhotoViewController()
        })
        let cameraButton = UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] action in
            self?.addCameraViewController()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(galleryButton)
        alert.addAction(cameraButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    private func addPhotoViewController() {
        let photoViewController = UIImagePickerController()
        photoViewController.sourceType = .photoLibrary
        photoViewController.allowsEditing = false
        photoViewController.delegate = self
        present(photoViewController, animated: true)
    }
    
    private func addCameraViewController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = .camera
            cameraViewController.allowsEditing = false
            cameraViewController.delegate = self
            present(cameraViewController, animated: true)
        } else {
            showNoCameraAlert()
        }
    }
    
    private func showNoCameraAlert() {
        let alertViewController = UIAlertController(title: "No Camera", message: "Sorry, this device hasn't got camera",
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        
        images.insert(image, at: 0)
        galleryCollectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            galleryCollectionView.reloadSections(indexSet)
        })
    }
    
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            as! GalleryCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let imagePreviewViewController = storyBoard.instantiateViewController(identifier: "ImagePreviewViewController")
            as! ImagePreviewViewController
        imagePreviewViewController.images = images
        imagePreviewViewController.selectedImageIndex = indexPath.row
        navigationController?.pushViewController(imagePreviewViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsCount = CGFloat(4)
        let spacingSize = CGFloat(8)
        let frameCV = collectionView.frame
        let cellWidth = frameCV.width / cellsCount
        let cellHeight = cellWidth
        let spacing = (cellsCount + 1) * spacingSize / cellsCount
        return CGSize(width: cellWidth - spacing, height: cellHeight - spacingSize * 2)
    }
    
}
