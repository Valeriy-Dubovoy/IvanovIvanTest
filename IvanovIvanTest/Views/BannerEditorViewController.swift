//
//  BannerEditorViewController.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 27.04.2022.
//

import UIKit

class BannerEditorViewController: UIViewController {

    var editableItem: Banner?
    
    private var isRed = false {
        didSet {
            redButton.isSelected = isRed
        }
    }
    private var isGreen = false {
        didSet {
            greenButton.isSelected = isGreen
        }
    }
    private var isBlue = false {
        didSet {
            blueButton.isSelected = isBlue
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        if saveBanner() {
            dismiss(animated: true)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func nameNextButtonPressed(_ sender: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBAction func redButtonPressed(_ sender: UIButton) {
        isRed = !isRed
    }
   
    @IBOutlet weak var greenButton: UIButton!
    
    @IBAction func greenButtonPressed(_ sender: UIButton) {
        isGreen = !isGreen
    }
    
    @IBOutlet weak var blueButton: UIButton!
    
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        isBlue = !isBlue
    }
    
    func updateUI() {
        nameTextField.text = ""
        isRed = false
        isGreen = false
        isBlue = false
        if let banner = editableItem {
            nameTextField.text = banner.name
            
            if let color = banner.color, !color.isEmpty {
                var justColors = color
                //remove "#"
                justColors.remove(at: justColors.startIndex)

                var colorsArray = [String]()

                for i in 0...2 {
                    let range = justColors.index(justColors.startIndex, offsetBy: i*2)...justColors.index(justColors.startIndex, offsetBy: i*2+1)
                    colorsArray.append( String( justColors[range] ) )
                }
                
                isRed = colorsArray[0].lowercased() == "ff"
                isGreen = colorsArray[1].lowercased() == "ff"
                isBlue = colorsArray[2].lowercased() == "ff"
            }
        }
    }
    
    func saveBanner() -> Bool {
        // Validation of required fields
        if nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the Customer!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            nameTextField.becomeFirstResponder()
            return false
        }
        
        let red = isRed ? "ff" : "00"
        let green = isGreen ? "ff" : "00"
        let blue = isBlue ? "ff" : "00"
        let color = "#\(red)\(green)\(blue)"
        
        if editableItem == nil {
            editableItem = Banner.init(context: AppDelegate.viewContext)
        }
        
        editableItem?.fillWith(name: nameTextField.text!, color: color, active: true)
        DBSupport.saveContext()

        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
