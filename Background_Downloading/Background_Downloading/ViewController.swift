//
//  ViewController.swift
//  Background_Downloading
//
//  Created by BANKUM-BLRM20 on 07/02/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func downloadData(from url: URL) {
        /*
         Optionally, set the earliestBeginDate property to schedule the download to begin at a particular point in the future. The download isn’t guaranteed to begin at precisely this time, but it won’t start sooner.

         To help the system schedule network activity efficiently, set the properties countOfBytesClientExpectsToSend and countOfBytesClientExpectsToReceive. These values are best-guess upper bounds on the expected byte count, and should account for headers as well as body data.
         */
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let backgorundTask = session.downloadTask(with: url)
        
        backgorundTask.earliestBeginDate = Date().addingTimeInterval(1*60)
        backgorundTask.countOfBytesClientExpectsToSend = 200
        backgorundTask.countOfBytesClientExpectsToReceive = 500 * 1024
        
        backgorundTask.resume()
    }
    
    @IBAction func startButtonTap(_ sender: UIButton) {
      let url = "https://resize.indiatvnews.com/en/resize/newbucket/715_-/2020/02/valentine-1580978619.jpg"
        guard let apiEndPoint = URL(string: url) else {
            return
        }
        downloadData(from: apiEndPoint)
    }
    
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("---didFinishDownloadingTo---started--\(location)")
    }
    //When all events have been delivered, the system calls
    // Executing the background URL session completion handler on the main queue
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            debugPrint("urlSessionDidFinishEvents---started---")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let backGroundCompletionHandler = appDelegate.backgroundSessionCompletionHandler  else {
                return
            }
            backGroundCompletionHandler()
        }
    }
}


