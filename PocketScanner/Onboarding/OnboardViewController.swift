//
//  OnboardViewController.swift
//  PocketScanner
//
//  Created by melvin on 27/04/22.
//

import UIKit

class OnboardViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Indicator: UIPageControl!
    @IBOutlet weak var skipBtn: UIButton!
    
    var scrollWidth: CGFloat! = 0.0
        var scrollHeight: CGFloat! = 0.0
    
    var titles = ["Welcome to Pocket Scanner","With Just A Click"]
        var descs = ["An image scanner that fit in your pocket to  copy selected text from a real image without pain.","Stop rewrite that text! Just scan it and copy paste it with just one click"]
        var imgs = ["onboard-1","onboard-2"]
    
    //get dynamic width and height of scrollview and save it
        override func viewDidLayoutSubviews() {
            scrollWidth = ScrollView.frame.size.width
            scrollHeight = ScrollView.frame.size.height
            
            Indicator.subviews.forEach {
                    $0.transform = CGAffineTransform(scaleX: 2, y: 2)
                }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
                //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview

                self.ScrollView.delegate = self
                ScrollView.isPagingEnabled = true
                ScrollView.showsHorizontalScrollIndicator = false
                ScrollView.showsVerticalScrollIndicator = false

                //crete the slides and add them
                var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

                for index in 0..<titles.count {
                    frame.origin.x = scrollWidth * CGFloat(index)
                    frame.size = CGSize(width: scrollWidth, height: scrollHeight)

                    let slide = UIView(frame: frame)

                    //subviews
                    let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
                    imageView.frame = CGRect(x:0,y:0,width:250,height:250)
                    imageView.contentMode = .scaleAspectFit
                    imageView.center = CGPoint(x:scrollWidth/2 - 20 ,y: scrollHeight/2 - 50)
                  
                    let txt1 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+30,width:scrollWidth-64,height:30))
                    txt1.textAlignment = .left
                    txt1.font = UIFont.boldSystemFont(ofSize: 20.0)
                    txt1.text = titles[index]

                    let txt2 = UILabel.init(frame: CGRect(x:32,y:txt1.frame.maxY+10,width:315,height:100))
                    txt2.textAlignment = .left
                    txt2.numberOfLines = 8
                    txt2.font = UIFont.systemFont(ofSize: 16.0)
                    txt2.text = descs[index]

                    slide.addSubview(imageView)
                    slide.addSubview(txt1)
                    slide.addSubview(txt2)
                    ScrollView.addSubview(slide)
                    Indicator.subviews.forEach {
                            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
                        }

                }

                //set width of scrollview to accomodate all the slides
                ScrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)

                //disable vertical scroll/bounce
                self.ScrollView.contentSize.height = 1.0

                //initial state
                Indicator.numberOfPages = titles.count
                Indicator.currentPage = 0
                Indicator.subviews.forEach {
                $0.transform = CGAffineTransform(scaleX: 2, y: 2)
            }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func skipToMain(_ sender: Any) {
        
    }
    @IBAction func pageChanged(_ sender: Any) {
            ScrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((Indicator?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            setIndiactorForCurrentPage()
        }

        func setIndiactorForCurrentPage()  {
            let page = (ScrollView?.contentOffset.x)!/scrollWidth
            Indicator?.currentPage = Int(page)
        }

}
