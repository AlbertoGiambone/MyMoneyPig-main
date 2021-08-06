//
//  AddBillViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 08/02/21.
//

import UIKit
import Firebase

class AddBillViewController: UIViewController, UITextFieldDelegate {

    //MARK: Connection
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    //MARK: limit text to number
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterAccepted = ",.0123456789"
        let allowedCharacterSet = CharacterSet(charactersIn: characterAccepted)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    var datePicker : UIDatePicker?
    
    //DoneButton
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @objc func datePickerDone() {
           dateTextField.resignFirstResponder()
       }

       @objc func dateChanged() {
        var newDate = datePicker?.date
        var dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .short
        dateTextField.text = dayFormatter.string(from: newDate!)
       }
    
    
    //MARK: Lifcycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //MARK: Picker Settigs
        
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker?.datePickerMode = .date
        datePicker!.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
               dateTextField.inputView = datePicker
               let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
               let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
               dateTextField.inputAccessoryView = toolBar
        
        
        //Date
        
        let day = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .short
        dateTextField.text = dayFormatter.string(from: day)

        // Mark Keyboard ToolBar setting
        
        let FooltoolBar = UIToolbar()
        FooltoolBar.sizeToFit()
        
        let FooldoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        FooltoolBar.setItems([FooldoneButton], animated: false)
        
        subjectTextField.inputAccessoryView = FooltoolBar
        
        amountTextField.inputAccessoryView = FooltoolBar
        amountTextField.delegate = self
        
        
        // Mark segmentIndex Text Color
        
        let titleTextAttributesForNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributesForSelected = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 102/255, blue: 204/255, alpha: 1.0)]
        segment.setTitleTextAttributes(titleTextAttributesForNormal, for: .normal)
        segment.setTitleTextAttributes(titleTextAttributesForSelected, for: .selected)
        
        
    }
    
    //MARK: Action
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    
   
        let db = Firestore.firestore()
        
        
        
        if amountTextField.hasText == true {
            
            if UserDefaults.standard.object(forKey: "userAnonymous") != nil {
            if segment.selectedSegmentIndex == 0 {
                
                var amountText = amountTextField.text
                amountText?.replace(",", with: ".")
                if Double(amountText!) == nil {
                    saveButton.isEnabled = false
                    print("SAVE BUTTON DISABLED!")
                }else{
                db.collection("Price").addDocument(data: [
                    "UID": UserDefaults.standard.object(forKey: "userAnonymous") as! String,
                    "subject": String(subjectTextField.text ?? ""),
                    "Bill date": String(dateTextField.text ?? ""),
                    "amount": String("\(amountText!)"),
                    "sign": String("false")
                ]) {
                    err in
                    if let err = err {
                        print("Error adding bill: \(err)")
                    }else{
                        
                        }
                    }
                }
            }else{
            
                var amountText = amountTextField.text
                amountText?.replace(",", with: ".")
            db.collection("Price").addDocument(data: [
                "UID": UserDefaults.standard.object(forKey: "userAnonymous") as! String,
                "subject": String(subjectTextField.text ?? ""),
                "Bill date": String(dateTextField.text ?? ""),
                "amount": String(amountText!),
                "sign": String("true")
            ]) {
                err in
                if let err = err {
                    print("Error adding bill: \(err)")
                }else{
                    
                    }
                }
            }
        }else{
            print("NO AMOUNT!")
            }
        navigationController?.popViewController(animated: true)
        }
        if UserDefaults.standard.object(forKey: "userApple") != nil {
            if segment.selectedSegmentIndex == 0 {
                
                var amountText = amountTextField.text
                amountText?.replace(",", with: ".")
                if Double(amountText!) == nil {
                    saveButton.isEnabled = false
                    print("SAVE BUTTON DISABLED!")
                }else{
                db.collection("Price").addDocument(data: [
                    "UID": UserDefaults.standard.object(forKey: "userApple") as! String,
                    "subject": String(subjectTextField.text ?? ""),
                    "Bill date": String(dateTextField.text ?? ""),
                    "amount": String("\(amountText!)"),
                    "sign": String("false")
                ]) {
                    err in
                    if let err = err {
                        print("Error adding bill: \(err)")
                    }else{
                        
                        }
                    }
                }
            }else{
            
                var amountText = amountTextField.text
                amountText?.replace(",", with: ".")
            db.collection("Price").addDocument(data: [
                "UID": UserDefaults.standard.object(forKey: "userApple") as! String,
                "subject": String(subjectTextField.text ?? ""),
                "Bill date": String(dateTextField.text ?? ""),
                "amount": String(amountText!),
                "sign": String("true")
            ]) {
                err in
                if let err = err {
                    print("Error adding bill: \(err)")
                }else{
                    
                }
            }
        }
            
        }else{
            print("NO AMOUNT!")
            }
        navigationController?.popViewController(animated: true)
        }
        
    }




//MARK: use . instead of , in DOUBLE value

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

extension String {
    mutating func replace(_ originalString:String, with newString:String) {
        self = self.replacingOccurrences(of: originalString, with: newString)
    }
}
