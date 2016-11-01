//
//  StartViewController.swift
//  NuWicam
//
//  Created by CCHSU20 on 10/5/16.
//  Copyright © 2016 Nuvoton. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    let TAG = "StartViewController:"
    var playerManager: PlayerManager?
    var cameraURL: String?
    
    //MARK: override UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        playerManager = PlayerManager.sharedInstance()
        let dic = playerManager?.dictionarySetting["Setup Camera"] as! NSDictionary
        if let URL = dic["URL"]{
            cameraURL = URL as? String
        }
        print("\(TAG) camera URL: \(cameraURL)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    @IBAction func enterLive(){
        if cameraURL != nil {
            let parameters: NSMutableDictionary = NSMutableDictionary.init(capacity: 1)
            parameters[KxMovieParameterDisableDeinterlacing] = true
            let kxmovie = KxMovieViewController.movieViewController(withContentPath: cameraURL, parameters: parameters as [AnyHashable: Any])
            present(kxmovie as! KxMovieViewController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
