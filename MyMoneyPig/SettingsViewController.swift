//
//  SettingsViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 07/02/21.
//

import UIKit
import FirebaseUI
import Firebase

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Connection
    
    @IBOutlet weak var currencyTextField: UITextField!
    
    @IBOutlet weak var syncButton: UIButton!
    
    //MARK: Picker settings

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row].moneylabel
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let totalView = UILabel()
        totalView.text = currency[row].moneylabel
        totalView.textColor = .darkGray
        totalView.textAlignment = .center
    
        return totalView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = currency[row].akrLabel
        
        currencyTextField.text = selected
        
    }
    
    
    private var currencyPicker: UIPickerView?
    
    
    var currency: [(moneylabel: String, akrLabel: String)] = [("🇪🇺EUR EU Euro", "🇪🇺€"), ("🇺🇸USD US dollar", "🇺🇸$"), ("🇯🇵JPY Japanese yen", "🇯🇵¥"), ("🇧🇬BGN Bulgarian lev", "🇧🇬BGN"), ("🇨🇿CZK Czech koruna", "🇨🇿Kč"), ("🇩🇰DKK Danish krone", "🇩🇰kr"), ("🇬🇧GBP Pound sterling", "🇬🇧£"), ("🇭🇺HUF Hungarian forint", "🇭🇺Ft"), ("🇵🇱PLN Polish zloty", "🇵🇱zł"), ("🇷🇴RON Romanian leu", "🇷🇴L"), ("🇸🇪SEK Swedish krona", "🇸🇪kr"), ("🇨🇭CHF Swiss franc", "🇨🇭Fr"), ("🇮🇸ISK Icelandic krona", "🇮🇸Íkr"), ("🇳🇴NOK Norwegian krone", "🇳🇴kr"), ("🇷🇺RUB Russian rouble", "🇷🇺₽"), ("🇹🇷TRY Turkish lira", "🇹🇷₺"), ("🇦🇺AUD Australian dollar", "🇦🇺$"), ("🇧🇷BRL Brazilian real", "🇧🇷R$"), ("🇨🇦CAD Canadian dollar", "🇨🇦$"), ("🇨🇳CNY Chinese yuan renminbi", "🇨🇳元"), ("🇭🇰HKD Hong Kong dollar", "🇭🇰$"), ("🇮🇩IDR Indonesian rupiah", "🇮🇩Rp"), ("🇮🇱ILS Israeli shekel", "🇮🇱₪"), ("🇮🇳INR Indian rupee", "🇮🇳₹"), ("🇰🇷KRW South Korean won", "🇰🇷₩"), ("🇲🇽MXN Mexican peso", "🇲🇽$"), ("🇲🇾MYR Malaysian ringgit", "🇲🇾RM"), ("🇳🇿NZD New Zealand dollar", "🇳🇿$"), ("🇵🇭PHP Philippine peso", "🇵🇭₱"), ("🇵🇭SGD Singapore dollar", "🇸🇬S$"), ("🇹🇭THB Thai baht", "🇹🇭฿"), ("🇿🇦ZAR South African rand", "🇿🇦R")]
    
    
    //MARK SyncButton settings
    
    
    @IBAction func SyncButtonpressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "ID")
            
          } catch let err {
            print(err)
                }
        
        
        if UserDefaults.standard.object(forKey: "userInfo") == nil {
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    self.showUserInfo(user:user)
                } else {
                    self.showLoginVC()
                }
            }
        }
    
    }
    
    //MARK: Login Page creation
    
    func showLoginVC() {
        let autUI = FUIAuth.defaultAuthUI()
        let providers = [FUIOAuth.appleAuthProvider()]
        
        autUI?.providers = providers
        
        let autViewController = autUI!.authViewController()
        autViewController.modalPresentationStyle = .fullScreen
        self.present(autViewController, animated: true, completion: nil)
    }
    
    //MARK: Apple sign in process
    
    func showUserInfo(user:User) {
        
        print("USER.UID: \(user.uid)")
        UserDefaults.standard.setValue(user.uid, forKey: "userInfo")
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let AppleUser = authDataResult?.user {
            print("GREAT!!! You Are Logged in as Apple User ID: \(AppleUser.uid)")
            UserDefaults.standard.setValue(AppleUser.uid, forKey: "userInfo")
            //DELETING ANONYMOUS ID
            UserDefaults.standard.removeObject(forKey: "ID")
            print("ID removed")
        }
    }
    
    
    
    //DoneButton
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    //MARK: lifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "userInfo") != nil {
            syncButton.alpha = 0
            syncButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)

        currencyPicker = UIPickerView()
        currencyTextField.inputView = currencyPicker
        currencyPicker?.backgroundColor = .white
        
        currencyPicker?.delegate = self
        currencyTextField.inputAccessoryView = toolBar
        
        
        currencyTextField.text = UserDefaults.standard.object(forKey: "CurrencySet") as? String
        
        /*
        let logo = UIImage(named: "TopBar.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        */
 
    }
    
  
    

    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "CurrencySet")
        
        UserDefaults.standard.set(String(currencyTextField.text!), forKey: "CurrencySet")
    }
    
    
}
