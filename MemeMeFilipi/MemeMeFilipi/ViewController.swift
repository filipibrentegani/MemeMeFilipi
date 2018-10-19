//
//  ViewController.swift
//  MemeMeFilipi
//
//  Created by Filipi Brentegani on 26/09/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: Constants
    
    private static let topText = "TOP"
    private static let bottomText = "BOTTOM"
    
    // MARK: IBOtlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialStateScreen()
        
        defineTextFieldStyle(topTextField)
        defineTextFieldStyle(bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Private Methods
    
    private func defineTextFieldStyle(_ textField: UITextField) {
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -5
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    private func save() {
        let _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    private func generateMemedImage() -> UIImage {
        
        setTopBottonToolbarsIsHidden(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        setTopBottonToolbarsIsHidden(false)
        
        return memedImage
    }
    
    private func setTopBottonToolbarsIsHidden(_ hide: Bool) {
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
    }
    
    private func setInitialStateScreen() {
        actionButton.isEnabled = false
        topTextField.isEnabled = false
        topTextField.text = ""
        bottomTextField.isEnabled = false
        bottomTextField.text = ""
        imageView.image = nil
        cancelButton.isEnabled = false
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func presentUIPickerController(_ sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    // MARK: IBActions
    
    @IBAction func onCameraButton(_ sender: Any) {
        presentUIPickerController(.camera)
    }
    
    @IBAction func onAlbumButton(_ sender: Any) {
        presentUIPickerController(.photoLibrary)
    }
    
    @IBAction func onActionButton(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        setInitialStateScreen()
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if textField == topTextField && text == ViewController.topText {
            topTextField.text = ""
        } else if textField == bottomTextField && text == ViewController.bottomText {
            bottomTextField.text = ""
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if textField == topTextField && text == "" {
            topTextField.text = ViewController.topText
        } else if textField == bottomTextField && text == "" {
            bottomTextField.text = ViewController.bottomText
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == topTextField {
            topTextField.endEditing(true)
        } else if textField == bottomTextField {
            bottomTextField.endEditing(true)
        }
        return true
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            topTextField.text = ViewController.topText
            bottomTextField.text = ViewController.bottomText
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
            cancelButton.isEnabled = true
            actionButton.isEnabled = true
        }
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
