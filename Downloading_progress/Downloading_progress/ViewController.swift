//
//  ViewController.swift
//  Downloading_progress
//
//  Created by BANKUM-BLRM20 on 07/02/22.
//

import UIKit

//download file when app is in backgroud
//progress bar
//central Notification center
//Push notification
class ViewController: UIViewController, URLSessionDownloadDelegate {
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
    }

    func getURLFromString(apiEndPoint: String) -> URL? {
        return URL(string: apiEndPoint)
    }
    
    func dowmloadImage(with url: URL) {
        let operatuionQueue = OperationQueue() //OperationQueue so that our downloadTask can run asynchronously without locking up the app
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: operatuionQueue)
        let dowmloadTask = session.downloadTask(with: url)
        dowmloadTask.resume()
        
    }
    //Starting the download
    @IBAction func startButtonTapped(_ sender: UIButton) {
        let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Polarlicht_2.jpg/1920px-Polarlicht_2.jpg?1568971082971"
//        let url = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        if let apiEndPoint = getURLFromString(apiEndPoint: url) {
            dowmloadImage(with: apiEndPoint)
        }
    }
    
    
    
    //Protocol method:
    
    /* Sent when a download task that has completed a download.  The delegate should
     * copy or move the file at the given location to a new location as it will be
     * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
     * still be called.
     */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("successfully downloaded the file : \(location)")
        
        //download done
        let data = readDataFromFile(location)
        //set image to imageview
        setImageToImageView(from: data)
        
    }
    // MARK: protocol stub for tracking download progress
    /* Sent periodically to notify the delegate of download progress. */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        
        let percentDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        debugPrint("---printing started--\(percentDownloaded * 100)--")
        DispatchQueue.main.async {
            self.progressLabel.text = "\(percentDownloaded * 100) %"
        }
    }
    
    
    // MARK: read downloaded data
    func readDataFromFile(_ url: URL) -> Data? {
        debugPrint("----read data from file started----")
        do {
        let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            return data
        } catch let error {
            debugPrint("reading file error: \(error)")
            return nil
        }
    }
    
    func getUIImageFromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func setImageToImageView(from data: Data?) {
        guard let imageData = data else {
            return
        }
        guard let image = getUIImageFromData(imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
        
    }
    
}

