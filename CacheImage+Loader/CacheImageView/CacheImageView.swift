//
//  CacheImageView.swift
//  CacheImage+Loader
//
//  Created by Murtaza Mehmood on 28/01/2023.
//

import UIKit

class CacheImage: UIImageView {
    
    private var activity: UIActivityIndicatorView?
    private var cache: NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        activity = UIActivityIndicatorView()
        activity?.translatesAutoresizingMaskIntoConstraints = false
        activity?.style = .medium
        
        self.addSubview(activity!)
        
        NSLayoutConstraint.activate([
            activity!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activity!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func downloadImage(image url: String,placeholder: String?) {
        guard let url = URL(string: url) else {
            self.image = (placeholder == nil) ? UIImage() : UIImage(named: placeholder!)
            return
        }
        guard let cacheImage = cache.object(forKey: url as AnyObject) as? UIImage else {
            activity?.startAnimating()
            self.image = nil
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error == nil {
                    DispatchQueue.main.async { [unowned self] in
                        self.activity?.stopAnimating()
                        self.activity = nil
                        let image = UIImage(data: data!)
                        self.cache.setObject(image as AnyObject, forKey: url as AnyObject)
                        self.image = image
                    }
                } else {
                    DispatchQueue.main.async { [unowned self] in
                        self.activity?.stopAnimating()
                        self.activity = nil
                        self.cache.removeObject(forKey: url as AnyObject)
                        self.image = (placeholder == nil) ? UIImage() : UIImage(named: placeholder!)
                    }
                }
            }.resume()
            
            return
        }
        
         
        self.image = cacheImage

    }
}
