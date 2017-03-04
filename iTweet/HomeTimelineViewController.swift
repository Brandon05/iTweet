//
//  HomeTimelineViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import Kingfisher
import AFNetworking
import SwiftLinkPreview

class HomeTimelineViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var timelineTableView: UITableView!
    
    var listFlowLayout = ListFlowLayout()
    var refreshControl: UIRefreshControl!
    let linkPreview = SwiftLinkPreview()
    
    var tweets = [Tweet]() {
        didSet {
            timelineTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView Settings
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.register(TweetTableViewCell.self)
        self.automaticallyAdjustsScrollViewInsets = false
        self.timelineTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        // Self-sizing magic!
        self.timelineTableView.rowHeight = UITableViewAutomaticDimension
        self.timelineTableView.estimatedRowHeight = 250 //Set this to any value that works for you.
        
        //Refresh Control
        addRefreshControl()
        
        // Nav Bar
        configureNavBar()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCurrentTimeline()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //let range = Range(uncheckedBounds: (lower: 0, upper: self.timelineTableView.numberOfSections))
        //self.timelineTableView.reloadSections(IndexSet(integersIn: range), with: .none)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        getCurrentTimeline()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            guard let destination = segue.destination as? ProfileViewController,
                let button = sender as? UIButton
                else { return }
            print(button.tag)
            print(tweets[button.tag])
            destination.user = tweets[button.tag].user
        }
        
        if segue.identifier == "TweetDetailSegue" {
            guard let destination = segue.destination as? TweetDetailViewController,
                let button = sender as? UIButton
                else { return }
            print(button.tag)
            print(tweets[button.tag])
            //destination.user = tweets[button.tag].user
        }
        
        if segue.identifier == "WebSegue" {
            guard let destination = segue.destination as? UINavigationController,
                let webVC = destination.viewControllers[0] as? ModalWebViewController,
                let button = sender as? UIButton
                else { return }
            print(button.tag)
            print(tweets[button.tag])
            webVC.urlString = tweets[button.tag].displayURL!
        }
    }
 

}

// MARK:- TweetCell Segue Events

extension HomeTimelineViewController {
    // Profile picture and screenname targets
    func profileButtonsTapped(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "ProfileSegue", sender: sender)
    }
    
    // Long Press Target for actionView UILongPressGestureRecognizer
    func longPressGesture() -> UILongPressGestureRecognizer {
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(HomeTimelineViewController.longPress(_:)))
        lpg.minimumPressDuration = 0.2
        return lpg
    }
    
    func longPress(_ sender: UILongPressGestureRecognizer) {
        //print(sender.view)
        if sender.state == .began {
        self.performSegue(withIdentifier: "TweetDetailSegue", sender: sender.view)
        }
    }
    
    func webViewTapGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeTimelineViewController.onTap(_:)))
        
        return tap
    }
    
    func onTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "WebSegue", sender: sender.view)
    }
}

//MARK: - Configurations for HomeTimelineViewController

extension HomeTimelineViewController {
    
    func configureNavBar() {
        let titleImage = UIImageView(image: #imageLiteral(resourceName: "twitter_white"))
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height
        let titleImageIconDimention = (navigationBarHeight ?? 44) * 0.75
        titleImage.frame = CGRect(x: 0, y: 0, width: titleImageIconDimention, height: titleImageIconDimention)
        titleImage.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = titleImage
    }
    
    func addRefreshControl() {
        // programatically adding pulltorefresh control, adjust color, call networkRequest()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        timelineTableView.insertSubview(refreshControl, at: 0)
        refreshControl.backgroundColor = UIColor.black.withAlphaComponent(0.8)//UIColor(hexString: "#63AEEB")
        refreshControl.tintColor = UIColor.white
    }
}

extension HomeTimelineViewController {
    // Sets up the data for Swift Preview class
    func setSwiftPreview(for cell: TweetTableViewCell, withTweet tweet: Tweet, completion: @escaping (Result<Any>) -> Void) {
        linkPreview.preview(tweet.displayURL, onSuccess: { (result: [String : AnyObject]) in
            DispatchQueue.main.async {
                
                let images = result["images"] as? [String]
                //print("IMAGES: - \((URL(string: images![0])!))")
                if images?.count != 0 {
                    let imageURL = URL(string: images![0])!
                    cell.urlImageView.setImageWith(imageURL)
                    //            self.urlImageView.kf.indicatorType = .activity
                    //            self.urlImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.2))])
                }
                cell.urlDescriptionLabel.text = result["description"] as? String
                cell.urlLabel.text = result["url"] as? String
                completion(Result.success("done"))
                
            }
        }, onError: { (error) in
            print(error)
            completion(Result.failure(error))
        })
        
    }
}


