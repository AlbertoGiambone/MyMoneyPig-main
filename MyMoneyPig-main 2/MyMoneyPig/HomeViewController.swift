//
//  HomeViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 02/02/21.
//

import UIKit
import Firebase
import FirebaseUI

class HomeViewController: UIViewController {

    //MARK: Connection
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    
    
    
    
    func showLoginVC() {
        let autUI = FUIAuth.defaultAuthUI()
        let providers = [FUIOAuth.appleAuthProvider()]
        
        autUI?.providers = providers
        
        let autViewController = autUI!.authViewController()
        autViewController.modalPresentationStyle = .fullScreen
        self.present(autViewController, animated: true, completion: nil)
    }
    
    func showUserInfo(user:User) {
        
        print("USER.UID: \(user.uid)")
        UserDefaults.standard.setValue(user.uid, forKey: "userInfo")
    }
    
    
    //MARK: view Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.showUserInfo(user:user)
            } else {
                self.showLoginVC()
            }
        }
        
        fetcFirestore()
        
    }
    
    
   
    
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("GREAT!!! You Are Logged in as \(user.uid)")
            UserDefaults.standard.setValue(user.uid, forKey: "userInfo")
        }
    }
    
    
    
    func getWeekBalance() {
        
        for j in wholeFirestore {
            
            let exampleDate = j.BillDate
        let today = Date()

        let dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .short

        let fromStringToDate = dayFormatter.date(from: exampleDate)
        let todayDateString = dayFormatter.string(from: today)
        let todayDateDate = dayFormatter.date(from: todayDateString)



        let calendar = NSCalendar.current as NSCalendar

        let date1 = calendar.startOfDay(for: fromStringToDate!)
        let date0 = calendar.startOfDay(for: todayDateDate!)

        let unit = NSCalendar.Unit.day
        let unitMont = NSCalendar.Unit.month

        let distance = calendar.components(unit, from: date0, to: date1, options: [])
        let monthDistance = calendar.components(unitMont, from: date0, to: date1, options: [])
            
            print("GIORNI DI DISTANZA: \(distance.day!)")
            
            
            if distance.day! > -8 {
                if j.sign == "false" {
                weekDouble.append(Double("-\(j.amount)")!)
                }else{
                    weekDouble.append(Double(j.amount)!)
                }
            }
            if monthDistance.month! > -2 {
                if j.sign == "false" {
                monthDouble.append(Double("-\(j.amount)")!)
                }else{
                    monthDouble.append(Double(j.amount)!)
                }
            }
        }
        
        let userCurrency = UserDefaults.standard.object(forKey: "CurrencySet") as? String ?? ""
        let weekSpent = weekDouble.reduce(0, +).truncate(places: 2)
        let monthSpent = monthDouble.reduce(0, +).truncate(places: 2)
        weekLabel.text = String("\(weekSpent) \(userCurrency)")
        monthLabel.text = String("\(monthSpent) \(userCurrency)")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stodo.removeAll()
        balanceArray.removeAll()
        weekDouble.removeAll()
        monthDouble.removeAll()
        wholeFirestore.removeAll()
    }
    
    
    
    
    //MARK: Action
    
    @IBAction func addBillButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "addBill", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBill" {
            _ = segue.destination as! AddBillViewController
        }
    }
    
    //MARK: Fetching Firestore
    
    let dataB = Firestore.firestore()

    var balanceArray = [String]()
    var stodo = [Double]()
    var wholeFirestore = [conto]()
    var weekDouble = [Double]()
    var monthDouble = [Double]()
    
    
    func fetcFirestore() {
        
        dataB.collection("Price").getDocuments() { [self](querySnapshot, err) in
            
            if let err = err {
                print("Error getting Firestore data: \(err)")
            }else{
                for documet in querySnapshot!.documents {
        
                    let r = documet.data()["UID"] as! String
                    let userID = UserDefaults.standard.object(forKey: "userInfo") as! String
                    if r == userID {
                        
                        self.balanceArray.append(documet.data()["amount"] as! String)
                        self.wholeFirestore.append(conto(UID: documet.data()["UID"] as! String, subject: documet.data()["subject"] as! String, BillDate: documet.data()["Bill date"] as! String, amount: documet.data()["amount"] as! String, docID: documet.documentID, sign: documet.data()["sign"] as! String))
                    }
                }
            }
            
            
            
            for y in self.wholeFirestore {
                if y.sign == "false" {
                    self.stodo.append(Double("-\(y.amount)")!)
                }else{
                    self.stodo.append(Double(y.amount)!)
                }
            }
            
            let defCurrency = UserDefaults.standard.object(forKey: "CurrencySet")
            self.balanceLabel.text = String("\(self.stodo.reduce(0, +).truncate(places: 2)) \(defCurrency ?? "")")
            self.getWeekBalance()
        }


    }
}
