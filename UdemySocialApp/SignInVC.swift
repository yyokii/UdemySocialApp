//
//  SignIn.swift
//  UdemySocialApp
//
//  Created by 東原与生 on 2017/03/15.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("JESS: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                
                print("JESS: User cancelled Facebook authentication")
            } else {
                
                print("JESS: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth (_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("JESS: Unable to authenticate with Firebase - \(error)")
            } else {
                
                print("JESS: Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    //exsisting user
                    print("JESS: Email user authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS: Unable to authenticate with Firebase using email")
                        } else {
                            //new user
                            print("JESS: Successfully authenticated with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn (id: String){
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}

