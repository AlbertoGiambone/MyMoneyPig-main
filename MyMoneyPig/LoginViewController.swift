//
//  LoginViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 23/06/21.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    func showLoginVC() {
        let autUI = FUIAuth.defaultAuthUI()
        let providers = [FUIOAuth.appleAuthProvider()]
        
        autUI?.providers = providers
        
        let autViewController = autUI!.authViewController()
        autViewController.modalPresentationStyle = .fullScreen
        self.present(autViewController, animated: true, completion: nil)
    }
    
//    func showHomeVC() {
//        let homeVC = HomeViewController()
//        homeVC.modalPresentationStyle = .fullScreen
//        self.present(homeVC, animated: true, completion: nil)
//    }
    
    func showUserInfo(user:User) {
        
        print("USER.UID: \(user.uid)")
        UserDefaults.standard.setValue(user.uid, forKey: "userInfo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                
                self.showUserInfo(user:user)
                
                self.performSegue(withIdentifier: "loggedIN", sender: self)
                
                print("ha ciclato su WillAppear")
            } else {
                //self.showLoginVC()
                self.tabBarController?.tabBar.isHidden = true
                print("ha ciclato su WillAppear")
            }
        }
        
        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                
                self.showUserInfo(user:user)
                
                self.performSegue(withIdentifier: "loggedIN", sender: self)
                print("ha ciclato su viewDidAppear con tabBar false")
                
            } else {
                //self.showLoginVC()
                print("ha ciclato su viewDidAppear")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logo.layer.cornerRadius = 64
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("GREAT!!! You Are Logged in as \(user.uid)")
            UserDefaults.standard.setValue(user.uid, forKey: "userInfo")
        }
    }

    
    //MARK: Action
    
    @IBAction func LoginTapped(_ sender: RoundButton) {
        
        
        self.showLoginVC()
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! initilaViewController
        
    }
    

    //MARK: Connection
    
    @IBOutlet weak var logo: UIImageView!
    
    
    
}
