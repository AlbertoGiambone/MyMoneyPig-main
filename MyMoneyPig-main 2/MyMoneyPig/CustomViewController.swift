//
//  CustomViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 07/02/21.
//

import UIKit
import Firebase

class CustomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //MARK: connection
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    
    
    
    
    //MARK: Tableview settings
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if segment.selectedSegmentIndex == 1 {
            return positiveOrdered.count
        }
        if segment.selectedSegmentIndex == 2 {
            return negativeOrdered.count
        }else {
            return billsOrdered.count
            }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let usd = UserDefaults.standard.object(forKey: "CurrencySet") as? String ?? ""
        if segment.selectedSegmentIndex == 0 {
            
            let y: String?
            
            if billsOrdered[indexPath.row].sign == "false" {
                y = String("- \(billsOrdered[indexPath.row].amount)")
            }else{
                y = String(billsOrdered[indexPath.row].amount)
            }
        let t = String("\(y!) \(usd)   \(billsOrdered[indexPath.row].subject)")
 
        print("\(t) eccooo illll TTTTTTT")
        cell.textLabel?.text = String(t)
        cell.textLabel?.font = UIFont(name: "Galvji", size: 18)
        cell.textLabel?.textColor = UIColor.systemBlue
        
        cell.detailTextLabel?.text = String(billsOrdered[indexPath.row].BillDate)
        cell.detailTextLabel?.font = UIFont(name: "Galvji", size: 15)
        cell.detailTextLabel?.textColor = UIColor.darkGray
        }
        if segment.selectedSegmentIndex == 1 {
            let t = String("\(positiveOrdered[indexPath.row].amount) \(usd)   \(positiveOrdered[indexPath.row].subject)")
            cell.textLabel?.text = String(t)
            cell.textLabel?.font = UIFont(name: "Galvji", size: 18)
            cell.textLabel?.textColor = UIColor.systemBlue
            
            cell.detailTextLabel?.text = String(positiveOrdered[indexPath.row].BillDate)
            cell.detailTextLabel?.font = UIFont(name: "Galvji", size: 15)
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }
        if segment.selectedSegmentIndex == 2 {
            let t = String("- \(negativeOrdered[indexPath.row].amount) \(usd)   \(negativeOrdered[indexPath.row].subject)")
            cell.textLabel?.text = String(t)
            cell.textLabel?.font = UIFont(name: "Galvji", size: 18)
            cell.textLabel?.textColor = UIColor.systemBlue
            
            cell.detailTextLabel?.text = String(negativeOrdered[indexPath.row].BillDate)
            cell.detailTextLabel?.font = UIFont(name: "Galvji", size: 15)
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if segment.selectedSegmentIndex == 0 {
                let g = billsOrdered[indexPath.row].docID
                
                db.collection("Price").document(g).delete()
                
                billsOrdered.remove(at: indexPath.row)
                self.table.deleteRows(at: [indexPath], with: .fade)
                table.reloadData()
            }
            if segment.selectedSegmentIndex == 1 {
                let m = positiveOrdered[indexPath.row].docID
                
                db.collection("Price").document(m).delete()
                
                positiveOrdered.remove(at: indexPath.row)
                self.table.deleteRows(at: [indexPath], with: .fade)
                table.reloadData()
                
            }
            if segment.selectedSegmentIndex == 2 {
                let m = negativeOrdered[indexPath.row].docID
                
                db.collection("Price").document(m).delete()
                
                negativeOrdered.remove(at: indexPath.row)
                self.table.deleteRows(at: [indexPath], with: .fade)
                table.reloadData()
            }
        }
    }
    
    var Dpassed: conto?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment.selectedSegmentIndex == 0 {
            
            Dpassed = billsOrdered[indexPath.row]
        }
        if segment.selectedSegmentIndex == 1 {
            Dpassed = positiveOrdered[indexPath.row]
        }
        if segment.selectedSegmentIndex == 2 {
            Dpassed = negativeOrdered[indexPath.row]
        }
        performSegue(withIdentifier: "goToEdit", sender: nil)
    }
    
    
    
    
    
    //MARK: Fetching Firestore
    
    let db = Firestore.firestore()
    
    var bills = [conto]()
    var billsOrdered = [conto]()
    var negativeArray = [conto]()
    var negativeOrdered = [conto]()
    var positiveArray = [conto]()
    var positiveOrdered = [conto]()
    
    func FetchFirestoreData() {
        
        let userID = UserDefaults.standard.object(forKey: "userInfo") as! String
        
        
        let queryRef = db.collection("Price")
        
        queryRef.getDocuments() {(querySnapshot, err) in
            
            if let err = err {
                print("Error getting Firestore data: \(err)")
            }else{
                for documet in querySnapshot!.documents {
                    let r = documet.data()["UID"] as! String
                    
                    if r == userID {
                        let t = conto(UID: documet.data()["UID"] as! String, subject: documet.data()["subject"] as! String, BillDate: documet.data()["Bill date"] as! String, amount: documet.data()["amount"] as! String, docID: documet.documentID, sign: documet.data()["sign"] as! String)
                    
                        self.bills.append(t)
                        
                        self.billsOrdered = self.bills.sorted(by: {$0.BillDate < $1.BillDate})
                        
                        let segno = documet.data()["sign"] as! String
                        
                        if segno == "false" {
                            self.negativeArray.append(t)
                            self.negativeOrdered = self.negativeArray.sorted(by: {$0.BillDate < $1.BillDate})
                        }
                        if segno == "true" {
                            self.positiveArray.append(t)
                            self.positiveOrdered = self.positiveArray.sorted(by: {$0.BillDate < $1.BillDate})
                        }
                        
                        self.table.reloadData()
                    }
                    
                }
            }
            
            
        }

    }
    
    
    
    
    //MARK: Lifecycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        FetchFirestoreData()
        table.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        table.dataSource = self
        table.delegate = self
        
        table.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bills.removeAll()
        billsOrdered.removeAll()
        positiveArray.removeAll()
        positiveOrdered.removeAll()
        negativeArray.removeAll()
        negativeOrdered.removeAll()
    }

    
    
    @IBAction func segmentChanging(_ sender: UISegmentedControl) {
        table.reloadData()
    }

    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let edVC = segue.destination as! EditingViewController
            edVC.docuPassed = Dpassed
            edVC.modalPresentationStyle = .fullScreen
        }
    }
    

}

