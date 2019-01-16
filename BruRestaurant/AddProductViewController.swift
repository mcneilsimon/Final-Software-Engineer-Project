//
//  AddProductViewController.swift
//  BruRestaurant
//
//  Created by Simon Mc Neil on 2018-11-21.
//  Copyright © 2018 Simon Mc Neil. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemNameLbl: UITextField!
    @IBOutlet weak var itemDescriptionField: UITextView!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var userID: String = ""
    
    @IBOutlet weak var beverageImage: UIImageView!
    
    var ref: DatabaseReference?
    var refToHomeController: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        itemDescription.layer.borderWidth = 0.5
        itemDescription.layer.borderColor = borderColor.cgColor
        itemDescription.layer.cornerRadius = 5.0
        
        self.itemNameLbl.delegate = self
        self.itemDescriptionField.delegate = self
        
        imagePicker.delegate = self
        let addImage = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(getImage))
        self.navigationItem.rightBarButtonItem = addImage
    }
    
    @objc func getImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        // Set photoImageView to display the selected image.
        beverageImage.image = selectedImage
        
        // Dismiss the picker.
    }

    @IBAction func submitInfoBtn(_ sender: Any) {
        var data = Data()
        data = (beverageImage.image!.jpegData(compressionQuality: 0.8))!
        
        let imageRef = Storage.storage().reference().child("\(itemNameLbl.text!).png")
        
        //update are storage with the image we selected
        DispatchQueue.main.async {
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print(error!)
                    return //error occured
                }
                let size = metadata.size
                print(size)
                
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    
                    let image = downloadURL.absoluteString
                    let title = self.itemNameLbl.text
                    let description = self.itemDescription.text
                    
                    self.ref!.child("Users/\(self.userID)/Items").childByAutoId()
                        .setValue(["Image": image, "Description": description, "Title": title])
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
}
