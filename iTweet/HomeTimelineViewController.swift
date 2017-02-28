//
//  HomeTimelineViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet var timelineCollectionView: UICollectionView!
    @IBOutlet var timelineTableView: UITableView!
    
    var listFlowLayout = ListFlowLayout()
    var refreshControl: UIRefreshControl!
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTimelineViewController {
    //MARK: - Configurations for HomeTimelineViewController
    
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

extension UIView {
    
    func applyMask() {
        let shape = CAShapeLayer()
        let shadow = NSShadow()
        
        //// General Declarations
        //let context = UIGraphicsGetCurrentContext()!
        
        //// Background Color
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        
        //// Shadow Declarations
        
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.28)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 4
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 10), byRoundingCorners: [.topRight, .bottomLeft], cornerRadii: CGSize(width: 40, height: 40))
        rectanglePath.close()
        //context.saveGState()
        //context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        UIColor.white.setFill()
        rectanglePath.fill()
        //context.restoreGState()
        
        
        shape.frame = self.bounds
        shape.path = rectanglePath.cgPath
        shape.borderWidth = 5
        shape.borderColor = UIColor.clear.cgColor
        shape.fillColor = UIColor.red.cgColor
        
        shape.shadowRadius = 100
        
        //shape.shadowColor = UIColor.black.withAlphaComponent(0.38).cgColor
        shape.shadowOffset = CGSize(width: 0, height: 0)
        shape.shadowPath = rectanglePath.cgPath
        
        self.layer.insertSublayer(shape, at: 0)
        self.clipsToBounds = true
    }
}
