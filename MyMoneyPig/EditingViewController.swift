//
//  EditingViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 19/02/21.
//

import UIKit
import Firebase

class EditingViewController: UIViewController, UITextFieldDelegate {

    
    //MARK: document from CustomViewController
    
    var docuPassed: conto?
    
    
    
    //MARK: Connection
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var subject: UITextField!
    
    @IBOutlet weak var dateX: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
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
           dateX.resignFirstResponder()
       }

       @objc func dateChanged() {
        var newDate = datePicker?.date
        var dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .short
        dateX.text = dayFormatter.string(from: newDate!)
       }
    
    //MARK: LifeCycle View
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Picker Settigs
        
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker?.datePickerMode = .date
        datePicker!.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
               dateX.inputView = datePicker
               let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
               let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
               dateX.inputAccessoryView = toolBar
    
        //Date
        
        let day = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .short
        dateX.text = dayFormatter.string(from: day)
     
        // Mark Keyboard ToolBar setting
        
        let FooltoolBar = UIToolbar()
        FooltoolBar.sizeToFit()
        
        let FooldoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        FooltoolBar.setItems([FooldoneButton], animated: false)
        
        subject.inputAccessoryView = FooltoolBar
        
        
        
        amount.inputAccessoryView = FooltoolBar
        amount.delegate = self
        
        
        // Mark segmentIndex Text Color
        
        let titleTextAttributesForNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributesForSelected = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 102/255, blue: 204/255, alpha: 1.0)]
        segment.setTitleTextAttributes(titleTextAttributesForNormal, for: .normal)
        segment.setTitleTextAttributes(titleTextAttributesForSelected, for: .selected)

        let giorno = docuPassed?.BillDate
        let giornoFormatter = DateFormatter()
        dayFormatter.dateStyle = .short
        let stringa = dayFormatter.string(from: day)
        
        subject.text = docuPassed?.subject
        dateX.text = stringa
        amount.text = docuPassed?.amount
        

    }
    
    
    //MARK: Action
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        
        
        
        if amount.hasText == true {
            
            if segment.selectedSegmentIndex == 0 {
                
                
                let docID = docuPassed?.docID
                var amountText = amount.text
                amountText?.replace(",", with: ".")
                
                let docREFERNCE = db.collection("Price").document(docID!)
                
                docREFERNCE.setData([
                    "UID": UserDefaults.standard.object(forKey: "userInfo") as! String,
                    "subject": String(subject.text ?? ""),
                    "Bill date": String(dateX.text ?? ""),
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
                    
            }
                
            
        if segment.selectedSegmentIndex == 1 {
            
                var amountText = amount.text
                amountText?.replace(",", with: ".")
                
                let docID = docuPassed?.docID
                let docREFERNCE = db.collection("Price").document(docID!)
                
                docREFERNCE.setData([
                "UID": UserDefaults.standard.object(forKey: "userInfo") as! String,
                "subject": String(subject.text ?? ""),
                "Bill date": String(dateX.text ?? ""),
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
            
        navigationController?.popViewController(animated: true)
        
    }
    
    
}



