//
//  FirstStartViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 22/07/21.
//

import UIKit

class FirstStartViewController: UIViewController {

    
    //MARK: Connection
    
    @IBOutlet weak var logo: UIImageView!
    
    
    
    //MARK: LifeCycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "userInfo") != nil {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.present(secondVC, animated:true, completion:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logo.layer.cornerRadius = 50
    }
    

}
