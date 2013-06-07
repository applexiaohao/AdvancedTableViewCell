//
//  ViewController.m
//  AdvancedTableViewCell
//
//  Created by 能登 要 on 13/06/07.
//
//

#import "ViewController.h"
#import "CustomCell.h"

@interface ViewController () <CustomCellDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet UIView* _backGroundView;
    NSURL* _lastSelecteURL;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [[UINib nibWithNibName:@"BackGroundView" bundle:nil] instantiateWithOwner:self options:nil];
    self.tableView.backgroundView = _backGroundView;
    _backGroundView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow;
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if( [cell isKindOfClass:[CustomCell class]] ){
        CustomCell* customCell = (CustomCell*)cell;
        customCell.delegate = self;
    }
    return cell;
}

- (void) customCell:(CustomCell*)customCell didSelectURL:(NSURL*)URL
{
    [[UIApplication sharedApplication] openURL:URL];
}

- (void) customCell:(CustomCell*)customCell didActionURL:(NSURL*)URL
{
    _lastSelecteURL = URL;
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Safari", nil];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ){
        [[UIApplication sharedApplication] openURL:_lastSelecteURL];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
