//
//  HomeViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 02/02/21.
//

import UIKit
import Firebase
import FirebaseUI

class HomeViewController: UIViewController, FUIAuthDelegate {

    //MARK: Connection
    
    @IBOutlet weak var balanceLabel: RoundLabel!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
 
    //MARK: Action
    
    @IBAction func LoginButtonTapped(_ sender: UIBarButtonItem) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
        do {
            try Auth.auth().signOut()
          } catch let err {
            print(err)
                }
            }else{
                print("You are Already logged in!!!")
            }
        }
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.present(secondVC, animated:true, completion:nil)
        
    }
    
    
    
    
    
    //MARK: reRouting if not logged in
    
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
                print("USER NOT LOGGED_IN")
            }
        }
        
        self.tabBarController?.tabBar.isHidden = false
        
        stodo.removeAll()
        balanceArray.removeAll()
        weekDouble.removeAll()
        monthDouble.removeAll()
        wholeFirestore.removeAll()
        
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
        let stringDate = dayFormatter.string(from: exampleDate)
            
            
            
        let fromStringToDate = dayFormatter.date(from: stringDate)
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
        
        /*
        if weekSpent < 0 {
            sevenNumber.textColor = UIColor(displayP3Red: 230/255, green: 0/255, blue: 115/256, alpha: 1)
        }else{
            sevenNumber.textColor = UIColor(displayP3Red: 0/255, green: 234/255, blue: 36/255, alpha: 1)
        }
        if monthSpent < 0 {
            thirtyNumber.textColor = UIColor(displayP3Red: 230/255, green: 0/255, blue: 115/256, alpha: 1)
        }else{
            thirtyNumber.textColor = UIColor(displayP3Red: 0/255, green: 234/255, blue: 36/255, alpha: 1)
        }
        */
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
    
        
        
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
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                //self.showUserInfo(user:user)
                self.performSegue(withIdentifier: "addBill", sender: nil)
            } else {
                self.showLoginVC()
            }
        }
        
        
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
                        
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        let d: Date = formatter.date(from: documet.data()["Bill date"] as! String)!
                        
                        self.balanceArray.append(documet.data()["amount"] as! String)
                        self.wholeFirestore.append(conto(UID: documet.data()["UID"] as! String, subject: documet.data()["subject"] as! String, BillDate: d, amount: documet.data()["amount"] as! String, docID: documet.documentID, sign: documet.data()["sign"] as! String))
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
            
            if stodo.reduce(0, +) == 0 {
            
            self.balanceLabel.text = String("\(self.stodo.reduce(0, +).truncate(places: 2)) \(defCurrency ?? "")")
            }else{
                self.balanceLabel.text = String("\(self.stodo.reduce(0, +).truncate(places: 2)) \(defCurrency ?? "")")
            }
            self.getWeekBalance()
            
            /*
            let yo = Double(self.stodo.reduce(0, +).truncate(places: 2))
            
            if yo < 0 {
                balanceLabel.backgroundColor = UIColor(displayP3Red: 230/255, green: 0/255, blue: 115/256, alpha: 1)
            }else{
                balanceLabel.backgroundColor = UIColor(displayP3Red: 0/255, green: 234/255, blue: 36/255, alpha: 1)
            }
            */
        }


    }
}
