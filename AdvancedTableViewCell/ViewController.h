//
//  ViewController.h
//  AdvancedTableViewCell
//
//  Created by 能登 要 on 13/06/07.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
