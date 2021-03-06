//
//  ProductColourModel.swift
//  OSA
//
//  Created by Happy Sanz Tech on 02/03/21.
//

import Foundation
import UIKit

struct ProductColourModel{
    struct Fetch {
        
        struct Request
        {
            var product_id : String?
            var size_id : String?
        }
        
        struct Response
        {
            var testObj: [ProductColourModels]
            var isError: Bool
            var message: String?
        }

        struct ViewModel
        {
           struct DisplayedProductColourData
           {
            var id : String?
            var product_id : String?
            var mas_color_id : String?
            var color_name : String?
            var color_code : String?
            var prod_mrp_price : String?
            var prod_default : String?
            var stocks_left : String?
            var prod_actual_price : String?
            
            }
              var displayedProductColourData: [DisplayedProductColourData]
    
        }
    }
}
