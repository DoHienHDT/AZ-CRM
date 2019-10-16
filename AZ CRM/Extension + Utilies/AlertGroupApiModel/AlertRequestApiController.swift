//
//  AlertRequestApiController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension UIAlertController {
    
    func addAlertAZSoft(Api: AlertRequestApiController.Api, selection: @escaping AlertRequestApiController.Selection) {
        var info: AlertRequestApiInfo?
        let selection: AlertRequestApiController.Selection = selection
        let buttonSelect: UIAlertAction = UIAlertAction(title: "Select", style: .default) { action in
            selection(info)
        }
        buttonSelect.isEnabled = false
        
        let vc = AlertRequestApiController(typeApi: Api) { new in
            info = new
            buttonSelect.isEnabled = new != nil
        }
        
        set(vc: vc)
        addAction(buttonSelect)
    }
}

class AlertRequestApiController: UIViewController, UISearchBarDelegate {
    
    //Mark: UI Metrics
    struct UI {
        static let rowHeight = CGFloat(50)
        static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    // MARK: Properties
    public typealias Selection = (AlertRequestApiInfo?) -> Swift.Void
    
    public enum Api {
        case dvtProducts
        case products
        case opportunitystatus
        case customers
        case staff
        case customerGroups
        case customersources
        case orderstatus
        case orderpaymentmethods
        case ordertransportmethods
        case moneytypes
        case opportunitymeettypes
        case tasktypes
        case taskprios
        case taskstatus
        case tasktitles
        case companies
        case tasks
    }
    
    var myArray: [String] = []
    
    fileprivate var typeApi: Api
    fileprivate var selection: Selection?
    fileprivate var searchTableview = [AlertRequestApiInfo]()
    fileprivate var orderedInfo = [AlertRequestApiInfo]()
    fileprivate var sortedInfoKeys = [String]()
    fileprivate var selectedInfo: AlertRequestApiInfo?
    
    fileprivate lazy var searchView: UIView = UIView()
    
    fileprivate lazy var searchController: UISearchController = {
        $0.searchResultsUpdater = self
        $0.searchBar.delegate = self
        $0.dimsBackgroundDuringPresentation = false
        /// true if search bar in tableView header
        $0.hidesNavigationBarDuringPresentation = true
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.textField?.textColor = .black
        $0.searchBar.textField?.clearButtonMode = .whileEditing
        return $0
    }(UISearchController(searchResultsController: nil))
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UI.separatorColor
        $0.bounces = true
        $0.backgroundColor = nil
        $0.tableFooterView = UIView()
        $0.sectionIndexBackgroundColor = .clear
        $0.sectionIndexTrackingBackgroundColor = .clear
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        $0.color = .lightGray
        return $0
    }(UIActivityIndicatorView(style: .whiteLarge))
    
    // MARK: Initialize
    
    required init(typeApi: Api, selection: @escaping Selection) {
        self.typeApi = typeApi
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchTableview = orderedInfo
            tableView.reloadData()
            return
        }
        
        switch typeApi {
        case .dvtProducts:
            break
        case .products:
            searchTableview = orderedInfo.filter({ (infoList) -> Bool in
                infoList.product[0].lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        case .opportunitystatus:
            break
        case .customers:
            searchTableview = orderedInfo.filter({ (infoList) -> Bool in
                infoList.customer[1].lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        case .staff:
            searchTableview = orderedInfo.filter({ (infoList) -> Bool in
                infoList.staff[1].lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        case .customerGroups:
            break
        case .customersources:
            break
        case .orderstatus:
            break
        case .orderpaymentmethods:
            break
        case .ordertransportmethods:
            break
        case .moneytypes:
            break
        case .opportunitymeettypes:
            break
        case .tasktypes:
            break
        case .taskprios:
            break
        case .taskstatus:
            break
        case .tasktitles:
            break
        case .companies:
            break
        case .tasks:
                searchTableview = orderedInfo.filter({ (infoList) -> Bool in
                      infoList.tasks[0].lowercased().contains(searchText.lowercased())
                })
                tableView.reloadData()
        }
    }
    
    deinit {
        let _ = searchController.view
        Log("has deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicatorView)
      
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .bottom
        definesPresentationContext = true
        
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.identifier)
        
        indicatorView.startAnimating()
        
        DispatchQueue.main.async {
            self.updateInfo()
        }
    }
    
    // list api Group
    func updateInfo() {
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                  if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                switch typeApi {
                    
                case .customers:
                    let param: Parameters = ["method": "customers","rtype":entity.last!.rtype!,"isadmin":entity.last!.isadmin!, "mact": entity.last!.mact!, "manv":entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd":entity.last!.mankd!,"seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .customers) { [unowned self] (info) in
                        
                        self.searchView.addSubview(self.searchController.searchBar)
                        self.tableView.tableHeaderView = self.searchView
                        
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .opportunitystatus:
                    let param: Parameters = ["method": "opportunitystatus","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .opportunitystatus) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .products:
                    let param: Parameters = ["method": "products","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .products) { [unowned self] (info) in
                        
                        self.searchView.addSubview(self.searchController.searchBar)
                        self.tableView.tableHeaderView = self.searchView
                        
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .dvtProducts:
                    let param: Parameters = ["method": "units","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .units) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .staff:
                    let param: Parameters = ["method": "staffs","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .staff) { [unowned self] (info) in
                        
                        self.searchView.addSubview(self.searchController.searchBar)
                        self.tableView.tableHeaderView = self.searchView
                        
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .customerGroups:
                    let param: Parameters = ["method": "customergroups","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .customerGroups) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .customersources:
                    let param: Parameters = ["method": "customersources","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .customersources) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .orderstatus:
                    let param: Parameters = ["method": "orderstatus","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .orderstatus) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .orderpaymentmethods:
                    let param: Parameters = ["method": "orderpaymentmethods","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .orderpaymentmethods) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .ordertransportmethods:
                    let param: Parameters = ["method": "ordertransportmethods","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .ordertransportmethods) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .moneytypes:
                    let param: Parameters = ["method": "moneytypes","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .moneytypes) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .opportunitymeettypes:
                    let param: Parameters = ["method": "opportunitymeettypes","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .opportunitymeettypes) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .tasktypes:
                    let param: Parameters = ["method": "tasktypes","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .tasktypes) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .taskprios:
                    let param: Parameters = ["method": "taskprios","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .taskprios) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .taskstatus:
                    let param: Parameters = ["method": "taskstatus","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .taskstatus) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .tasktitles:
                    let param: Parameters = ["method": "tasktitles","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .tasktitles) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .companies:
                    let param: Parameters = ["method": "companies","seckey": urlRegister.last!.seckey!]
                    AlertRequestApi.getInfo(param: param, type: .companies) { [unowned self] (info) in
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                case .tasks:
                    
                    let date = Date()
                    let dateformat = DateFormatter()
                    dateformat.dateFormat = "dd/MM/yyyy"
                    let dateString = dateformat.string(from: date)
                    let previousMonth = Calendar.current.date(byAdding: .month, value: -3, to: date)!
                    let previousMonthString = dateformat.string(from: previousMonth)
                    
                    let param: Parameters = ["method":"tasks","rtype":entity.last!.rtype!, "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!,"manv":entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay":previousMonthString,"denngay":dateString,"seckey":urlRegister.last!.seckey!]
                    
                    AlertRequestApi.getInfo(param: param, type: .tasks) { [unowned self] (info) in
                        
                        self.searchView.addSubview(self.searchController.searchBar)
                        self.tableView.tableHeaderView = self.searchView
                        
                        self.orderedInfo = info
                        self.searchTableview = self.orderedInfo
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                    break
                }
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.tableHeaderView?.height = 57
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame.size.width = searchView.frame.size.width
        searchController.searchBar.frame.size.height = searchView.frame.size.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.center = view.center
        preferredContentSize.height = tableView.contentSize.height
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
    }
    
}

extension AlertRequestApiController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
    
}

extension AlertRequestApiController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = searchTableview[indexPath.row]
        selectedInfo = info
        selection?(selectedInfo)
    }
}

extension AlertRequestApiController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let info =  searchTableview[indexPath.row]
        
        let cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.identifier) as! AlertTableViewCell
        switch typeApi {
        case .customers:
            cell.textLabel?.text = info.customer[1]
            if let selected = selectedInfo, selected.customer == info.customer {
                cell.isSelected = true
            }
        case .dvtProducts:
            cell.textLabel?.text = info.dvtProduct?[1]
            if let selected = selectedInfo, selected.dvtProduct == info.dvtProduct {
                cell.isSelected = true
            }
        case .opportunitystatus:
            cell.textLabel?.text = info.opportunitystatus[1]
            if let selected = selectedInfo, selected.opportunitystatus == info.opportunitystatus {
                cell.isSelected = true
            }
        case .products:
            cell.textLabel?.text = info.product[0]
            if let selected = selectedInfo, selected.product == info.product {
                cell.isSelected = true
            }
        case .staff:
            cell.textLabel?.text = info.staff[1]
            if let selected = selectedInfo, selected.staff == info.staff {
                cell.isSelected = true
            }
        case .customerGroups:
            cell.textLabel?.text = info.customerGroups[1]
            if let selected = selectedInfo, selected.customerGroups == info.customerGroups {
                cell.isSelected = true
            }
        case .customersources:
            cell.textLabel?.text = info.customersources[1]
            if let selected = selectedInfo, selected.customersources == info.customersources {
                cell.isSelected = true
            }
        case .orderstatus:
            cell.textLabel?.text = info.orderstatus[1]
            if let selected = selectedInfo, selected.orderstatus == info.orderstatus {
                cell.isSelected = true
            }
        case .orderpaymentmethods:
            cell.textLabel?.text = info.orderpaymentmethods[1]
            if let selected = selectedInfo, selected.orderpaymentmethods == info.orderpaymentmethods {
                cell.isSelected = true
            }
        case .ordertransportmethods:
            cell.textLabel?.text = info.ordertransportmethods[1]
            if let selected = selectedInfo, selected.ordertransportmethods == info.ordertransportmethods {
                cell.isSelected = true
            }
        case .moneytypes:
            cell.textLabel?.text = info.moneytypes[1]
            if let selected = selectedInfo, selected.moneytypes == info.moneytypes {
                cell.isSelected = true
            }
        case .opportunitymeettypes:
            cell.textLabel?.text = info.opportunitymeettypes[1]
            if let selected = selectedInfo, selected.opportunitymeettypes == info.opportunitymeettypes {
                cell.isSelected = true
            }
        case .tasktypes:
            cell.textLabel?.text = info.tasktypes[1]
            if let selected = selectedInfo, selected.tasktypes == info.tasktypes {
                cell.isSelected = true
            }
        case .taskprios:
            cell.textLabel?.text = info.taskprios[1]
            if let selected = selectedInfo, selected.taskprios == info.taskprios {
                cell.isSelected = true
            }
        case .taskstatus:
            cell.textLabel?.text = info.taskstatus[1]
            if let selected = selectedInfo, selected.taskstatus == info.taskstatus {
                cell.isSelected = true
            }
        case .tasktitles:
            cell.textLabel?.text = info.tasktitles[1]
            if let selected = selectedInfo, selected.tasktitles == info.tasktitles {
                cell.isSelected = true
            }
        case .companies:
            cell.textLabel?.text = info.companies[1]
            if let selected = selectedInfo, selected.companies == info.companies {
                cell.isSelected = true
            }
        case .tasks:
            cell.textLabel?.text = info.tasks[1]
            if let selected = selectedInfo, selected.tasks == info.tasks {
                cell.isSelected = true
            }
        }
        return cell
    }
}
extension UITableView {
    func selectRows(at indexPaths: [IndexPath], animated: Bool = false) {
        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: animated, scrollPosition: .none)
        }
    }
}
