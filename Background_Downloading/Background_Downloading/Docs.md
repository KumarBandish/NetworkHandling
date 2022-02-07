#  Downloading Files in the Background
Create tasks that download files while your app is inactive.

##step1: Configure the Background Session

    func downloadData(from url: URL) {
    
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
       
    }

##step2: Create and Schedule the Download Task

        let backgorundTask = session.downloadTask(with: url)
        
        backgorundTask.earliestBeginDate = Date().addingTimeInterval(1*60)
        backgorundTask.countOfBytesClientExpectsToSend = 200
        backgorundTask.countOfBytesClientExpectsToReceive = 500 * 1024
        
        backgorundTask.resume()
        


##step3: Handle App Suspension


###If your app is in the background, the system may suspend your app while the download is performed in another process. In this case, when the download finishes, the system resumes the app 

in AppDeelegate: 
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    
        func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        debugPrint("-calling started---handleEventsForBackgroundURLSession--")
        backgroundSessionCompletionHandler = completionHandler
    }
    

##step4: Access the File, or Move It to a Permanent Location


###When all events have been delivered, the system calls the urlSessionDidFinishEvents(forBackgroundURLSession:) method of URLSessionDelegate. 
###At this point, fetch the backgroundCompletionHandler stored by the app delegate and execute it.

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("---didFinishDownloadingTo---started--\(location)")
    }
    
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
