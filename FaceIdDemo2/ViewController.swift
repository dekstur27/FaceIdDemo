//
//  ViewController.swift
//  FaceIdDemo2
//
//  Created by Ss on 8/3/23.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var useBiometricsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTap(_ sender: UIButton) {
        let context = LAContext()
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("biometrics is available")
            
            switch context.biometryType {
                
            case .none:
                print("Device have no available biometrics")
            case .touchID:
                print("biometrics type: TouchID")
            case .faceID:
                print("biometrics type: FaceID")
            @unknown default:
                print("unknown")
            }

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "I need your identity to continue") { authorized, error in
                guard error == nil else {
                    self.checkBiometricsError(error: error)
                    return
                }
                
                if authorized {
                    print("Authorized!")
                } else {
                    print("Not authorized?")
                }
            }
        }
        
        guard error == nil else {
            print(String(describing: error))
            checkBiometricsError(error: error)
            return
        }
        
        print("done")
    }
    
    func checkBiometricsError(error: Error?) {
        guard let localAuthError = error as? LAError else {
            print(String(describing: error?.localizedDescription))
            return
        }

        switch localAuthError.code {
        case .appCancel:
            print("Authentication was canceled by application")
        case .authenticationFailed:
            print("Authentication was not successful because user failed to provide valid credentials.")
        case .biometryLockout:
            print("""
            Authentication was not successful because there were too many failed biometry attempts and
            biometry is now locked. Passcode is required to unlock biometry, e.g. evaluating
            LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
            """)
        case .biometryNotAvailable:
            print("Authentication could not start because biometry is not available on the device.")
        case .biometryNotEnrolled:
            print("Authentication could not start because biometry has no enrolled identities.")
        case .userCancel:
            print("Authentication was canceled by user (e.g. tapped Cancel button).")
        case .invalidContext:
            print("LAContext passed to this call has been previously invalidated.")
        case .passcodeNotSet:
            print("Authentication could not start because passcode is not set on the device.")
        case .notInteractive:
            print("Authentication failed because it would require showing UI which has been forbidden by using interactionNotAllowed property.")
        case .systemCancel:
            print("Authentication was canceled by system (e.g. another application went to foreground).")
        case .userFallback:
            print("Authentication was canceled because the user tapped the fallback button (Enter Password).")
        default:
            print(String(describing: localAuthError.localizedDescription))
        }
    }
}

