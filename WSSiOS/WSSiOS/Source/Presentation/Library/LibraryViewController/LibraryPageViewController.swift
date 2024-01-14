//
//  LibraryPageViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

class LibraryPageViewController: UIPageViewController {

    //MARK: - Properties
    
    private var tabBarDummyText = ["전체", "읽음", "읽는 중", "하차", "읽고 싶음"]
    
    
    //MARK: - UI Components

    private var libraryPages = [UIViewController]()
    private var initialPage = 0
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Custom TabBar
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
