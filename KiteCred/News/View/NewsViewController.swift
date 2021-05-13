//
//  NewsViewController.swift
//  Kite
//
//  Created by Dileep Jaiswal on 17/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {

    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    var categoryTableView = CategoryTableView()
    var documentInteractionController:UIDocumentInteractionController!
    let viewModel = NewsModelView()
    var viewHidden = true
    var isCategoryHidden = true
    var selectedIndex: Int = 0
    var item: NewsLink?

    var visibleCellIndexPath: IndexPath? {
        let visibleRect = CGRect(origin: newsCollectionView.contentOffset, size: newsCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = newsCollectionView.indexPathForItem(at: visiblePoint)
        return visibleIndexPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setStatus()
        let defaults = UserDefaults.standard
        let langCode = defaults.string(forKey: "languageCode")
        loadNewsArticale()
        getArticales()
        newsCollectionView.register(UINib(nibName: "LastCViewCell", bundle: nil), forCellWithReuseIdentifier: "LastCViewCell")
        loadCategoryView()
        view.bringSubviewToFront(topView)
        navigationController?.isNavigationBarHidden = true
        viewModel.delegate = self
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.isScrollEnabled = true
        newsCollectionView.isPagingEnabled = true
        newsCollectionView.showsVerticalScrollIndicator = false
        newsCollectionView.reloadData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.newsCollectionView.addGestureRecognizer(tap)
        showHideView(hidden: viewHidden)
    }
    
    //MARK: Private functions
    private func getArticales() {
        newsCollectionView.reloadData()
    }
    
    //MARK: Private function
    
    func setStatus() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
            //Set status bar background colour
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.red
            //Set navigation bar subView background colour
            for view in self.navigationController?.navigationBar.subviews ?? [] {
                view.tintColor = UIColor.white
                view.backgroundColor = UIColor.red
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topSafeArea: CGFloat
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
        } else {
            topSafeArea = topLayoutGuide.length
        }
        initialCalculation(height: topSafeArea)
    }
    
    func initialCalculation(height: CGFloat) {
        let size = self.view.frame.size
        let cellSize = CGSize(width:size.width , height:size.height - height)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        newsCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func loadNewsArticale() {
        if !Reachability.isConnectedToNetwork(){
            if RealmManager.shared.hasItems(with: ArticaleModel.self, filter: .updatedAt) {
                SnackbarView.shared.showAlert(message: NetworkConstant.Snackbar.offline, alertType: .hideAction, to: self)
            } else {
                loadNoInternetConnection()
            }
            return
        }
        fetchArticale()
    }
    
    func refreshNewsArticale() {
        if !Reachability.isConnectedToNetwork(){
            viewModel.isOnline = false
            DispatchQueue.main.async {
                self.moveCellonTop(animation: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
               SnackbarView.shared.showAlert(message: NetworkConstant.Snackbar.offline, alertType: .hideAction, to: self)
            }
            return
        }
        DispatchQueue.main.async {
            Spinner.start()
        }
        fetchArticale()
    }
    
    func fetchArticale() {
        if !RealmManager.shared.hasItems(with: ArticaleModel.self, filter: .updatedAt) {
            DispatchQueue.main.async {
                Spinner.start()
            }
        }
        self.viewModel.fetchNewsData()
    }
    
    func loadCategoryView() {
        categoryTableView.frame = CGRect(x: UIDevice.isPad ? -220 : -180, y: 0, width: UIDevice.isPad ? 220 : 180, height: self.view.frame.size.height)
        categoryTableView.categoryDelegte = self
        self.view.addSubview(categoryTableView)
    }
    
    func showHideView(hidden: Bool) {
        topView.isHidden = hidden
        bottomView.isHidden = hidden
    }
    
    func loadWhatsApp() {
        let article = viewModel.getArticleWith(index: selectedIndex)
        let message = "\(article.title) \n\(article.full_url) \n via- paper poll"
        var queryCharSet = NSCharacterSet.urlQueryAllowed
        // if your text message contains special characters like **+ and &** then add this line
        queryCharSet.remove(charactersIn: "+&")
        if let escapedString = message.addingPercentEncoding(withAllowedCharacters: queryCharSet) {
            if let whatsappURL = URL(string: "whatsapp://send?text=\(escapedString)") {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [: ], completionHandler: nil)
                } else {
                    debugPrint("please install WhatsApp")
                }
            }
        }
    }
    
    @IBAction func sideBarButtonTapped(_ sender: UIButton) {
        viewHidden = true
        showHideView(hidden: true)
        isCategoryHidden = !isCategoryHidden
        isCategoryHidden ? categoryTableView.hide() : categoryTableView.show()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        refreshNewsArticale()
        viewHidden = true
        showHideView(hidden: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        loadWhatsApp()
    }
      
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if isCategoryHidden == false {
            isCategoryHidden = true
            categoryTableView.hide()
            return
        }
        if visibleCellIndexPath?.row == viewModel.getArticlesCount() {
            hideTopBottmView()
        } else {
            viewHidden = !viewHidden
            showHideView(hidden: viewHidden)
        }
    }
    
    func hideTopBottmView() {
        viewHidden = true
        showHideView(hidden: viewHidden)
    }
    
    func loadMessageView(message: MessageModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let messageVC = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageVC.delegate = self
        messageVC.messageModel = message
        messageVC.modalPresentationStyle = .fullScreen
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func loadNoInternetConnection() {
        let font = UIFont(name: "HelveticaNeue-Bold", size: UIDevice.isPad ? 28 : 20)
        let message = MessageModel(imageName: "noInternet", title: "No Internet Connection!", message: "Please check your internet connection and try again.", font: font!, buttonType: .noInternet)
        loadMessageView(message: message)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideTopBottmView()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideTopBottmView()
    }
}

extension NewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getArticlesCount() > 0 ? (viewModel.getArticlesCount() + 1) : viewModel.getArticlesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == viewModel.getArticlesCount()
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastCViewCell", for: indexPath) as! LastCViewCell
            let font = UIFont(name: "HelveticaNeue-Bold", size: UIDevice.isPad ? 32 : 25)
            let message = MessageModel(imageName: "great", title: "Great!", message: "You've read all stories Please refresh for more.", font: font!, buttonType: .sucesses)
            cell.delegate = self
            cell.configureCell(message: message)
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
            cell.delegate = self
            let news = viewModel.getArticleWith(index: indexPath.row)
            cell.configureCellWith(articale: news)
            cell.tag = news.id
            return cell
        }
    }
}

extension NewsViewController: NewsCollectionViewCellDelegate {
    func readMoreButtonTapped(sender: UITapGestureRecognizer) {
        if !Reachability.isConnectedToNetwork(){
            SnackbarView.shared.showAlert(message: NetworkConstant.Snackbar.offline, alertType: .hideAction, to: self)
            return
        }
        guard let indexPath = newsCollectionView.indexPathForItem(at: sender.location(in: self.newsCollectionView)) else {
            return
        }
        let news = viewModel.getArticleWith(index: indexPath.row)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewsWebViewController") as! NewsWebViewController
        nextViewController.webViewUrl = news.full_url
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}

extension NewsViewController: NewsModelViewDelegate {
    func failToLoadCategory(message: MessageModel) {
        Spinner.stop()
        SnackbarView.shared.showAlert(message: message.message, alertType: .hideAction, to: self)
    }
    
    func loadDataFailureWith(message: MessageModel) {
        Spinner.stop()
        loadMessageView(message: message)
    }
    
    func dataLoadSuccessfully() {
        DispatchQueue.main.async {
            Spinner.stop()
            self.moveCellonTop(animation: false)
            self.getArticales()
        }
    }
    
    func moveCellonTop(animation: Bool) {
        self.newsCollectionView.reloadData()
        let top = CGPoint(x: self.newsCollectionView.contentOffset.x,
                          y: self.newsCollectionView.adjustedContentInset.top)
        self.newsCollectionView.setContentOffset(top, animated: animation)
    }
}

extension NewsViewController: CategoryTableViewDelegate {
    func tableView(_didSelectRowAt indexPath: IndexPath, model: CategoryModel) {
        isCategoryHidden = true
        self.categoryTableView.hide()
        if !Reachability.isConnectedToNetwork(){
            SnackbarView.shared.showAlert(message: NetworkConstant.Snackbar.offline, alertType: .hideAction, to: self)
            return
        }
        DispatchQueue.main.async {
            Spinner.start()
        }
        viewModel.fetchCategoryNewsDataWith(id: model.id)
    }
}

extension NewsViewController: MessageViewCDelegate {
    func tryAgain() {
        loadNewsArticale()
        if Reachability.isConnectedToNetwork(){
            dismissViewControllers()
            if categoryTableView.modelView.categoryCount() == 0 {
                categoryTableView.loadCategoryData()
            }
        }
    }
    
    func dismissViewControllers() {
        if let topVC = UIApplication.getTopViewController() as? MessageViewController {
           topVC.dismiss(animated: false, completion: nil)
        }
    }
    
    func backButtonPressed() {
        
    }
}

extension NewsViewController: LastCViewCellDelegate {
    func backButtonPressed(_ sender: UIButton) {
        moveCellonTop(animation: true)
    }
    
    func refreshButtonPressed(_ sender: UIButton) {
        refreshNewsArticale()
    }
}

extension NewsViewController: SnackbarViewDelegate {
    func hideActionButton() {
        SnackbarView.shared.hideAlert(to: self)
    }
}

