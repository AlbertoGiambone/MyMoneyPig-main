//
//  FirstStartViewController.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 22/07/21.
//

import UIKit
import Firebase
import FirebaseUI

class FirstStartViewController: UIViewController, FUIAuthDelegate {

    
    //MARK: Connection
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var AnonymousButton: UIButton!
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "userAnonymous") != nil {
            AnonymousButton.isHidden = true
            AnonymousButton.isEnabled = false
        }
        
        logo.layer.cornerRadius = 50
    }
    
    //MARK: Sign In Function
    
    override func viewDidAppear(_ animated: Bool) {
        signInTrust()
    }
    
    func showUserInfo(user:User) {

        print("USER.UID: \(user.uid)")
        UserDefaults.standard.setValue(user.uid, forKey: "userApple")
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("GREAT!!! You Are Logged in as \(user.uid)")
            UserDefaults.standard.setValue(user.uid, forKey: "userApple")
        }
    }
    
    func showLoginVC() {
        let autUI = FUIAuth.defaultAuthUI()
        let providers = [FUIOAuth.appleAuthProvider()]
        
        autUI?.providers = providers
        
        let autViewController = autUI!.authViewController()
        autViewController.modalPresentationStyle = .fullScreen
        self.present(autViewController, animated: true, completion: nil)
    }
    
    
    //MARK: Segue to Home if logged in
    
    func signInTrust() {
        if UserDefaults.standard.object(forKey: "userApple") != nil || UserDefaults.standard.object(forKey: "userAnonymous") != nil {
            DispatchQueue.main.async { // <<<<< (new)
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! TabBarController
                secondVC.modalPresentationStyle = .fullScreen // <<<<< (switched)
                self.present(secondVC, animated:true, completion:nil)
                print("USER LOGGED IN!!!")
            }
        } else {
            print("USER NOT LOGGED IN")
        }
        
    }
    
    
    
    //MARK: Acrion
    
    @IBAction func AppleSignIn(_ sender: UIButton) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.showUserInfo(user:user)
                UserDefaults.standard.setValue(user.uid, forKey: "userApple")
                
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! TabBarController
                secondVC.modalPresentationStyle = .fullScreen // <<<<< (switched)
                self.present(secondVC, animated:true, completion:nil)
                UserDefaults.standard.removeObject(forKey: "userAnonymous")
                print("APPLE USER LOGGED IN!!!")
                
                
            } else {
                self.showLoginVC()
            }
        }
        
    }
    
    
    @IBAction func AnonymousSignIn(_ sender: UIButton) {
        
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            UserDefaults.standard.setValue(user.uid, forKey: "userAnonymous")
            if isAnonymous == true {
                print("User is signed in with UID \(user.uid)")
                UserDefaults.standard.removeObject(forKey: "userApple")
                
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! TabBarController
                    self.present(secondVC, animated:true, completion:nil)
            
                }
            
            }
        
    }
    
}
