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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in _: UICollectionView) -> Int {
        updateFlag()
        return (isProviceOrder) ? provinceList.count : yearList.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateFlag()
        return (isProviceOrder) ? getOrderCount(province: provinceList[section]) :
                                  getOrderCount(year: yearList[section])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as? ImageCollectionViewCell {
            
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = false
            cell.clipsToBounds = true
            
            var order = orderList[indexPath.row]
            
            updateFlag()
            
            if (isProviceOrder) {
                if let item = provinceOrder[provinceList[indexPath.section]] {
                    order = item[indexPath.row]
                }
            } else {
                if let item = yearOrder[yearList[indexPath.section]] {
                    order = item[indexPath.row]
                }
            }
            
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        updateFlag()
        switch kind {
        case UICollectionElementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as? OrderCollectionReusableView {
                headerView.textlabel.text = (isProviceOrder) ? "\(provinceList[indexPath.section]) (\(getOrderCount(province: provinceList[indexPath.section])) Orders)" : "\(yearList[indexPath.section]) (\(getOrderCount(year: yearList[indexPath.section])) Orders)"
                return headerView
            }
        default:
            fatalError("This should never happen!!")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    let token = "c32313df0d0ef512ca64d5b336a0d7c6"
    let rawURL = "https://shopicruit.myshopify.com/admin/orders.json?"
    typealias objectJSON = [Any]
    typealias arrayJSON = [String: Any]
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))

    var orderList: [Order] = []
    var pageNumber: Int = 1
    var palette: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
    
    var provinceList : [String] = []
    var yearList : [Int] = []
    
    var isProviceOrder = false

    var provinceOrder: Dictionary = [String:[Order]]()
    var yearOrder: Dictionary = [Int:[Order]]()
    
    func fetchData(page: Int) {
        reset()
        let sv = UIViewController.displaySpinner(onView: view)
        if let url = URL(string: "\(rawURL)page=\(page)&access_token=\(token)") {
            
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

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

                                            self.provinceList.append(pro)
                                            self.yearList.append(Int(self.getYear(rawDate: createData))!)
                                            
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
                        self.organize()
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
            isProviceOrder = false
        } else {
            // Default: ordered by year
            reloadOrders(isYear: true, completion: {})
            isProviceOrder = true
        }
    }
    
    func getOrderCount(province: String) -> Int {
        return (provinceOrder[province]?.count)!
    }
    
    func getOrderCount(year: Int) -> Int {
        return (yearOrder[year]?.count)!
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
    
    func organize() {
        provinceList = provinceList.unique()
        yearList = yearList.unique()
        provinceList = provinceList.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        yearList = yearList.sorted {$0 < $1}
        
        provinceOrder = orderList.group(by: { $0.province })
        yearOrder = orderList.group(by: { $0.year })
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
    
    func updateFlag() {
        guard let isOrderedByYear = UserDefaults.standard.object(forKey: Constants.keyOrderFlag) as? Bool else {
            return;
        }
        isProviceOrder = !isOrderedByYear
    }
    
    func reset() {
        orderList.removeAll()
        provinceList.removeAll()
        yearList.removeAll()
        provinceOrder.removeAll()
        yearOrder.removeAll()
    }

    @IBAction func didNextOnClick(_: Any) {
        pageNumber += 1
        fetchData(page: pageNumber)
    }
}

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Set up custom cell
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        fetchData(page: pageNumber)
        
        // Set up header
        let headerNib = UINib.init(nibName: "OrderCollectionReusableView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderCell")
        
        // Content offset
        collectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFlag()
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
