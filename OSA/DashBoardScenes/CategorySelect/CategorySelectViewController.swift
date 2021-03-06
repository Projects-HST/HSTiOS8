//
//  CategorySelectViewController.swift
//  OSA
//
//  Created by Happy Sanz Tech on 25/02/21.
//

import UIKit
import SDWebImage

protocol CategorySelectDisplayLogic: class
{
    func successFetchedItems(viewModel: CategorySelectModel.Fetch.ViewModel)
    func errorFetchingItems(viewModel: CategorySelectModel.Fetch.ViewModel)
}

protocol SubCategoryListDisplayLogic: class
{
    func successFetchedItems(viewModel: SubCategoryListModel.Fetch.ViewModel)
    func errorFetchingItems(viewModel: SubCategoryListModel.Fetch.ViewModel)
}

class CategorySelectViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,CategorySelectDisplayLogic,SubCategoryListDisplayLogic {
    
   
    @IBOutlet weak var categoryCount: UILabel!
    @IBOutlet weak var selectCategeryCollectionView: UICollectionView!
    @IBOutlet weak var subCategoryListCollectionView: UICollectionView!
    
    var router: (NSObjectProtocol & CategorySelectRoutingLogic & CategorySelectDataPassing)?
    var router2: (NSObjectProtocol & SubCategoryListRoutingLogic & SubCategoryListDataPassing)?
    var interactor: CategorySelectBusinessLogic?
    var interactor2: SubCategoryListBusinessLogic?
    var displayedCategorySelectData: [CategorySelectModel.Fetch.ViewModel.DisplayedCategorySelectData] = []
    var displayedSubCategoryListData: [SubCategoryListModel.Fetch.ViewModel.DisplayedSubCategoryListData] = []
    
    var id = String()
    var parent_id = String()
    var category_image = String()
    var category_desc = String()
    var category_name = String()
    var selectedCategoryId = String()
    var idArr = [String]()
    var categoryArr = [String]()
    var product_id = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchItems(request: CategorySelectModel.Fetch.Request(cat_id:id))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        let viewController = self
        let interactor = CategorySelectInteractor()
        let presenter = CategorySelectPresenter()
        let router = CategorySelectRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        
        let viewController2 = self
        let interactor2 = SubCategoryListInteractor()
        let presenter2 = SubCategoryListPresenter()
        let router2 = SubCategoryListRouter()
        viewController2.interactor2 = interactor2
        interactor2.presenter2 = presenter2
        presenter2.viewController2 = viewController2
        router2.viewController2 = viewController2
        router2.dataStore = interactor2
    }
    
    func successFetchedItems(viewModel: CategorySelectModel.Fetch.ViewModel) {
        
        displayedCategorySelectData = viewModel.displayedCategorySelectData
        print(displayedCategorySelectData.count)
        self.categoryArr.removeAll()
        self.idArr.removeAll()
        for items in displayedCategorySelectData{
        let id = items.id
        let categoryName = items.category_name
            
        self.idArr.append(id!)
        self.categoryArr.append(categoryName!.capitalized)
        }
        
        self.categoryArr.insert("ALL", at: 0)
        self.idArr.insert("ALL", at: 0)
            
//        self.selectedCategoryId = String (self.idArr[0])
        self.selectCategeryCollectionView.reloadData()
        print(idArr)
        print(categoryArr)
            
    }
    
    func errorFetchingItems(viewModel: CategorySelectModel.Fetch.ViewModel) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.selectCategeryCollectionView
        {
        return categoryArr.count
        }
        else
        {
        return displayedSubCategoryListData.count
        }
    }
    
    func successFetchedItems(viewModel: SubCategoryListModel.Fetch.ViewModel) {
        displayedSubCategoryListData = viewModel.displayedSubCategoryListData
        print(displayedSubCategoryListData.count)
        self.subCategoryListCollectionView.reloadData()
        self.categoryCount.text = String("\(GlobalVariables.shared.categoryList_count) items")
        
    }
    
    func errorFetchingItems(viewModel: SubCategoryListModel.Fetch.ViewModel) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.selectCategeryCollectionView
        {
        let cell = selectCategeryCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectCategorySegmentCell
//        let catTitle = displayedCategorySelectData[indexPath.row]
            cell.catLabel.text = categoryArr[indexPath.row]
          return cell
         }
        else
        {
            let cell = subCategoryListCollectionView.dequeueReusableCell(withReuseIdentifier: "subCatList", for: indexPath) as! SubCategoryListCollectionViewCell
            let catArr = displayedSubCategoryListData[indexPath.row]
            cell.productTitlelabel.text = catArr.product_name
            cell.MrpPriceLabel.text = catArr.prod_mrp_price
            cell.categoryImage.sd_setImage(with: URL(string: catArr.product_cover_img!), placeholderImage: UIImage(named: ""))
              return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.selectCategeryCollectionView
        {
        print("You selected cell #\(indexPath.item)!")
        let selectedIndex = Int(indexPath.item)
        let sel = self.idArr[selectedIndex]
        self.selectedCategoryId = String (sel)
        interactor2?.fetchItems(request: SubCategoryListModel.Fetch.Request(cat_id:id,sub_cat_id:selectedCategoryId,user_id:"1"))
        } else
        {
            let data = displayedSubCategoryListData[indexPath.row]
            self.product_id = data.id!
            self.performSegue(withIdentifier: "to_productDetail", sender: self)
        }
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "to_productDetail")
         {
         let vc = segue.destination as! ProductDetailsViewController
            vc.product_id = self.product_id
     }
   }
}

