//
//  SettingsViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 07/02/21.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Connection
    
    @IBOutlet weak var currencyTextField: UITextField!
    

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
    
    
    
    
    
    
    //DoneButton
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    //MARK: lifeCycle
    
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
