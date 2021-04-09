//
//  SearchResultViewController.swift
//  Nearby
//
//  Created by cmStudent on 2021/04/09.
//

import UIKit
import MapKit

class SearchResultViewController: UIViewController {

    // MARK: - @IBOutlets
    /// 検索窓口
    @IBOutlet private weak var searchTextField: UITextField!
    /// マップ
    @IBOutlet private weak var mapView: MKMapView!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - Reusable
extension SearchResultViewController: Reusable {}
