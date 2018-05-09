//
//  HomeViewController.swift
//  Shopify
//
//  Copyright © 2018 com.jpeng.go.shopify. All rights reserved.
//

import UIKit

struct Constants {
    static let keyOrderFlag = "isOrderedByYear"
}

extension UIViewController {
    class func displaySpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        return spinnerView
    }

    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    let token = "c32313df0d0ef512ca64d5b336a0d7c6"
    let rawURL = "https://shopicruit.myshopify.com/admin/orders.json?"
    typealias objectJSON = [Any]
    typealias arrayJSON = [String: Any]
    typealias JSONDictionary = [Any]
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    var orderList: [Order] = []
    var pageNumber: Int = 1
    var palette: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        fetchData(page: pageNumber)
    }

    func fetchData(page: Int) {

        orderList.removeAll()
        
        let sv = UIViewController.displaySpinner(onView: view)

        if let url = URL(string: "\(rawURL)page=\(page)&access_token=\(token)") {
            // create the session object
            let session = URLSession.shared

            // now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "GET" // set http method as POST

            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, _, error in

                guard error == nil else {
                    return
                }

                guard let data = data else {
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? arrayJSON {
                        print(json.count)
                        if let orders = json["orders"] as? objectJSON {
                            for ele in orders {
                                if let content = ele as? arrayJSON {
                                    if let email = content["email"] as? String,
                                        let createData = content["created_at"] as? String,
                                        let totalPrice = content["total_price"] as? String,
                                        let financialStatus = content["financial_status"] as? String,
                                        let items = content["line_items"] as? objectJSON,
                                        let shippingInfo = content["shipping_address"] as? arrayJSON {

                                        if let street = shippingInfo["address1"] as? String,
                                            let city = shippingInfo["city"] as? String,
                                            let pro = shippingInfo["province"] as? String,
                                            let country = shippingInfo["country_code"] as? String,
                                            let firstName = shippingInfo["first_name"] as? String,
                                            let lastName = shippingInfo["last_name"] as? String {

                                            self.orderList.append(Order(cName: "\(firstName) \(lastName)",
                                                                        cEmail: email,
                                                                        fAddress: "\(street), \(city), \(pro), \(country)",
                                                                        iCount: items.count,
                                                                        tPrice: totalPrice,
                                                                        cDate: createData,
                                                                        fStatue: financialStatus, fYear: Int(self.getYear(rawDate: createData))!, cProvince: pro, colorIndex: Int(arc4random_uniform(UInt32(self.palette.count)))))
                                        }
                                    }
                                }
                            }
                        }
                    }

                    DispatchQueue.main.sync {
                        self.reloadOrders()
                        self.collectionView.reloadData()
                        UIViewController.removeSpinner(spinner: sv)
                        self.animateTable()
                    }
                } catch let error {
                    UIViewController.removeSpinner(spinner: sv)
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // return dataList.count;
        print(orderList.count)
        return orderList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as? ImageCollectionViewCell {

            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = false
            cell.clipsToBounds = true

            let order = orderList[indexPath.row]

            cell.setCell(name: order.name,
                         email: order.email,
                         address: order.address,
                         count: order.count,
                         price: order.price,
                         date: order.date,
                         statue: order.status)
            cell.backgroundColor = palette[order.color]
            return cell
        }
        //this should never be called
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
    }

    @IBAction func openSetting(_: Any) {
        blurEffectView.alpha = 0.0
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        UIView.animate(withDuration: 0.25) { () -> Void in
            self.blurEffectView.alpha = 1.0
        }

        let settingView = SettingPopUpViewController(nibName: "SettingPopUpViewController", bundle: nil)
        settingView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(settingView, animated: true, completion: nil)
    }

    func reloadOrders() {
        if let isOrderedByYear = UserDefaults.standard.object(forKey: Constants.keyOrderFlag) as? Bool {
            reloadOrders(isYear: isOrderedByYear, completion: {})
        } else {
            // Default: ordered by year
            reloadOrders(isYear: true, completion: {})
        }
    }

    func reloadOrders(isYear: Bool, completion: () -> Void) {
        (isYear) ? reorderByYear() : reorderByProvince()
        collectionView.reloadData()
        completion()
    }

    func reorderByYear() {
        orderList = orderList.sorted(by: { $0.year < $1.year })
    }

    func reorderByProvince() {
        orderList = orderList.sorted(by: { $0.province < $1.province })
    }

    func getYear(rawDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"

        if let date = dateFormatterGet.date(from: rawDate) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
            return "0"
        }
    }

    func animateTable() {
        collectionView.layoutIfNeeded()

        let cells = collectionView.visibleCells
        let tableHeight: CGFloat = collectionView.bounds.size.height

        for i in cells {
            let cell: UICollectionViewCell = i as UICollectionViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }

        var index = 0

        for a in cells {
            let cell: UICollectionViewCell = a as UICollectionViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)

            index += 1
        }
    }

    @IBAction func didNextOnClick(_: Any) {
        pageNumber += 1
        fetchData(page: pageNumber)
    }
}
