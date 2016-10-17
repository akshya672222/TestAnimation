//
//  ContactViewController.m
//  TestAnimation
//


#import "ContactViewController.h"
#import "AppDelegate.h"
#import "LibAnimation.h"

#define myAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface ContactViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UIGestureRecognizerDelegate>
{
    ContactTableViewCell *contactTableCell;
    
    ContactTableViewCell *cellTemp;
    
    NSIndexPath *indexPathPrev;
    
    NSArray *arrayImage;
    NSArray *arrayName;
    
    BOOL isAnimationPerformed;
    
    CGFloat cornerRadius;
    CGFloat cornerRadiusForPutBack;
    LibAnimation *globalObj;
    
    BOOL isCellInit;
    NSInteger count;
    CGFloat tblCellHeight;
}

@property (strong, nonatomic) NSMutableSet *expandedIndexPaths;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.expandedIndexPaths = [NSMutableSet set];
    count = 0;
    
    arrayImage = @[[UIImage imageNamed:@"Digit"],[UIImage imageNamed:@"Digit5"],[UIImage imageNamed:@"Digit4"],[UIImage imageNamed:@"Digit3"],[UIImage imageNamed:@"Digit5"],[UIImage imageNamed:@"Digit4"],[UIImage imageNamed:@"Digit2"],[UIImage imageNamed:@"Digit4"],[UIImage imageNamed:@"Digit3"],[UIImage imageNamed:@"Digit5"],[UIImage imageNamed:@"Digit4"],[UIImage imageNamed:@"Digit"]];
    
    arrayName = @[@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW",@"JON SNOW"];
    
    self.viewProfileHolder.hidden = YES;
    
    [self.view layoutIfNeeded];
    self.viewProfileHolder.transform = CGAffineTransformMakeScale(0.25, 0.25);
    
    self.viewProfileHolder.layer.cornerRadius = self.viewProfileHolder.frame.size.width*2;
    self.viewProfileHolder.layer.masksToBounds = YES;
    [self.view layoutIfNeeded];
    
    myAppDelegate.contactViewC = self;
    
    [self.tableViewContact setDataSource:self];
    [self.tableViewContact setDelegate:self];
    self.tableViewContact.rowHeight = UITableViewAutomaticDimension;
    self.tableViewContact.estimatedRowHeight = 50.0f;
//    tblCellHeight = 50.0f;
    self.tableViewContact.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewContact.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayName.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    contactTableCell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"contact"];
    
    [contactTableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    contactTableCell.lblMoreDetail.text = [NSString stringWithFormat:@"Row - %ld",indexPath.row+1];
    
    [contactTableCell.imageViewContactPhoto setImage:[arrayImage objectAtIndex:indexPath.row]];
    contactTableCell.imageViewContactPhoto.layer.cornerRadius = contactTableCell.imageViewContactPhoto.frame.size.height/2;
    contactTableCell.imageViewContactPhoto.layer.masksToBounds = YES;
    contactTableCell.imageViewContactPhoto.layer.shouldRasterize = YES;
    [contactTableCell.imageViewContactPhoto setTag:indexPath.row];
    contactTableCell.imageViewContactPhoto.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImageView:)];
    [gestureRecognizer setDelegate:self];
    [contactTableCell.imageViewContactPhoto addGestureRecognizer:gestureRecognizer];

    tblCellHeight = contactTableCell.viewVisible.frame.size.height;
    
    contactTableCell.lblName.text = [arrayName objectAtIndex:indexPath.row];
    
    contactTableCell.withDetails = [self.expandedIndexPaths containsObject:indexPath];
    
    return contactTableCell;
}


-(void)popImageView:(UITapGestureRecognizer *)gesture{
    
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:[gesture.view tag] inSection:0];
    
    ContactTableViewCell *tCell = (ContactTableViewCell *)[self.tableViewContact cellForRowAtIndexPath:indexP];
    
    if([self.expandedIndexPaths containsObject:indexP]){
        
        globalObj = [[LibAnimation alloc]initWithImageView:tCell.imageViewContactPhoto colorForCenterViewWithWhite:0.0 alpha:1.0];
        
        CGRect frame = [[UIApplication sharedApplication].keyWindow convertRect:tCell.imageViewContactPhoto.frame fromView:tCell];
        
        [globalObj animateImageViewForImageFromRect:frame];
        
        
    }else{
        
        
        globalObj = [[LibAnimation alloc]initWithView:tCell.imageViewContactPhoto colorForCenterViewWithWhite:0.5 alpha:0.7];
        
        CGPoint center = [tCell convertPoint:tCell.imageViewContactPhoto.center toView:nil];
        
        [globalObj setFromCenter:center];
        [globalObj setToCenter:self.view.center];
        [globalObj setFromScale:CGPointMake(1.0, 1.0)];
        [globalObj setToScale:CGPointMake(3.0, 3.0)];
        [globalObj setAnimationDuration:0.5];
        [globalObj animateViewFromCircleToSquare];
        
        
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.expandedIndexPaths containsObject:indexPath]) {
        
        ContactTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell animateClosed];

        [self.expandedIndexPaths removeObject:indexPath];
        [tableView beginUpdates];

        [self.view layoutIfNeeded];
        self.constraintTableViewTopSpaceFromLayoutGuide.constant = self.constraintTableViewTopSpaceFromLayoutGuide.constant + tblCellHeight;
        
        UIEdgeInsets edgeInset = tableView.contentInset;
        edgeInset.top = edgeInset.top - tblCellHeight;
        tableView.contentInset = edgeInset;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.view layoutIfNeeded];
            
        }completion:^(BOOL finished) {
            
        }];

        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        [cell layoutIfNeeded];
        cell.constraintArrowDownBottomSpace.constant = 5;
        [cell layoutIfNeeded];
        
        cell.constraintArrowDownBottomSpace.constant = 105;

        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [cell layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [cell layoutIfNeeded];
            cell.constraintArrowDownBottomSpace.constant = 5;
            [cell layoutIfNeeded];
            
            [cell.imgArrowDown setImage:[UIImage imageNamed:@"ArrowDown"]];
            [cell.imgArrowUp setImage:[UIImage imageNamed:@"ArrowUp"]];
            
        }];
        
        [tableView endUpdates];

        
    } else {
        
        [self.expandedIndexPaths addObject:indexPath];
        
        [tableView beginUpdates];
        
        [self.view layoutIfNeeded];
        self.constraintTableViewTopSpaceFromLayoutGuide.constant = - tblCellHeight * self.expandedIndexPaths.count;
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.view layoutIfNeeded];
            
        }completion:^(BOOL finished) {
            
            UIEdgeInsets edgeInset = tableView.contentInset;
            edgeInset.top = tblCellHeight *self.expandedIndexPaths.count;
            tableView.contentInset = edgeInset;
            
        }];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        
        ContactTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell layoutIfNeeded];
        cell.constraintArrowDownBottomSpace.constant = 105;
        [cell layoutIfNeeded];
        cell.constraintArrowDownBottomSpace.constant = 5;
        [UIView animateWithDuration:0.2 animations:^{
            [cell layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            [cell.imgArrowDown setImage:[UIImage imageNamed:@"ArrowUp"]];
            [cell.imgArrowUp setImage:[UIImage imageNamed:@"ArrowDown"]];
            
        }];
        
        [cell animateOpen];
    }

    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:243.0/255 green:235.0/255 blue:224.0/255 alpha:1] : [UIColor clearColor];
    cell.backgroundColor = color;
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (IBAction)addbtn:(id)sender {
    
}

- (IBAction)contactbtn:(id)sender {
    
}

- (IBAction)emailbtn:(id)sender {
    
}

@end
