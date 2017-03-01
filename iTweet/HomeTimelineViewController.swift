//
//  HomeTimelineViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var timelineCollectionView: UICollectionView!
    @IBOutlet var timelineTableView: UITableView!
    
    var listFlowLayout = ListFlowLayout()
    var refreshControl: UIRefreshControl!
    
    //let longPress = UILongPressGestureRecognizer(target: self, action: #selector(HomeTimelineViewController.onLongPress(_:)))
    
    var tweets = [Tweet]() {
        didSet {
            //timelineCollectionView.reloadData()
            timelineTableView.reloadData()
            let range = Range(uncheckedBounds: (lower: 0, upper: self.timelineTableView.numberOfSections))
            self.timelineTableView.reloadSections(IndexSet(integersIn: range), with: .none)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Settings
        //timelineCollectionView.delegate = self
        //timelineCollectionView.dataSource = self
        
        //timelineCollectionView.collectionViewLayout = listFlowLayout
        //timelineCollectionView.register(TweetCell.self)
        
        //TableView Settings
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.register(TweetTableViewCell.self)
        self.automaticallyAdjustsScrollViewInsets = false
        self.timelineTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        // Self-sizing magic!
        self.timelineTableView.rowHeight = UITableViewAutomaticDimension
        self.timelineTableView.estimatedRowHeight = 200 //Set this to any value that works for you.
        
        
        if let flowLayout = timelineCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = CGSize(width: 200, height: 200)
        }
        
        // TweetCell Gesture Delegate & Target
        //longPress.delegate = self
        //longPress.addTarget(self, action: #selector(HomeTimelineViewController.onLongPress(_:)))
        //longPress.minimumPressDuration = 0.2
        
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
        let range = Range(uncheckedBounds: (lower: 0, upper: self.timelineTableView.numberOfSections))
        self.timelineTableView.reloadSections(IndexSet(integersIn: range), with: .none)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        timelineTableView.layoutSubviews()
//        timelineTableView.setNeedsUpdateConstraints()
//        timelineTableView.updateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        getCurrentTimeline()
    }
    
    //MARK:- NavBar
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.cellForItem(at: indexPath)
//        
//        return CGSize(width: collectionView.frame.width - 6, height: 300)
//    }

    
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
        print(sender.view)
        if sender.state == .began {
        self.performSegue(withIdentifier: "TweetDetailSegue", sender: sender.view)
        }
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


