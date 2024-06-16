//
//  ViewController.swift
//  LazyLoadingDemo
//
//  Created by Jinali Chavda on 16/05/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionViewImage:UICollectionView!
    
    let downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "download image queue"
        return queue
    }()
    
    let imageUrls = [
        "https://www.learningcontainer.com/wp-content/uploads/2020/07/Sample-JPEG-Image-File-Download.jpg",
        "https://images.dog.ceo//breeds//schnauzer-miniature//n02097047_1921.jpg",
        "https://images.dog.ceo//breeds//bluetick//n02088632_403.jpg",
        "https://images.dog.ceo//breeds//terrier-patterdale//320px-05078045_Patterdale_Terrier.jpg",
        "https://images.dog.ceo//breeds//terrier-norfolk//n02094114_1490.jpg",
        "https://www.learningcontainer.com/wp-content/uploads/2020/07/Sample-JPEG-Image-File-Download.jpg",
        "https://images.dog.ceo//breeds//havanese//00100trPORTRAIT_00100_BURST20191103202017556_COVER.jpg",
        "https://via.placeholder.com/1000/0000FF/808080%20?Text=PAKAINFO.com",
        "https://via.placeholder.com/1000/FF0000/FFFFFF?Text=yttags.com",
        "https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
        "https://www.learningcontainer.com/wp-content/uploads/2020/07/Sample-JPEG-Image-File-Download.jpg",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell" , for: indexPath) as! collectionCell
        cell.configure(strURL: imageUrls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
    }
    
}

class collectionCell :UICollectionViewCell {
    @IBOutlet weak var imgShow:UIImageView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    func configure(strURL:String) {
        activityIndicator.startAnimating()

        let operation = DownloadTaskOperation(url: strURL, completion: { [weak self]image, errordata in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.imgShow.image = image
            }
        })
        DownloadOpertaionQueue.shared.addOperation(operation)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.hidesWhenStopped = true

        self.addSubview(self.activityIndicator)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = self.imgShow.center
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgShow.image = nil
        self.activityIndicator.stopAnimating()
    }
    
}
