//
//  ViewController.m
//  Shoppy
//
//  Created by Admin Dev on 6/6/17.
//  Copyright © 2017 Kinetic Bytes. All rights reserved.
//

#import "ViewController.h"
#import "Configs.h"
#import "StoreItem.h"
#import "StoreItemCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegateFlowLayout>
{
    NSInteger _pageSize;
}

@property (nonatomic, strong) NSMutableArray<StoreItem*>* storeItems;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSData*>* imageCache;

@end

@implementation ViewController

static NSString * const reuseIdentifier = @"storeitem";

- (void)viewDidLoad {
    [super viewDidLoad];

    /***Not required when using storyboard cells
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];***/

    // Do any additional setup after loading the view, typically from a nib.
    
    self.storeItems = [[NSMutableArray<StoreItem*> alloc] init];
    self.imageCache = [[NSMutableDictionary<NSString*, NSData*> alloc] init];
    
    //load the first page of items
    _pageSize = 48; //divisible by 2,3 and 4

    [self loadNextStoreItemsPage];
}

- (void)loadNextStoreItemsPage {

    NSInteger startItemIdx = self.storeItems.count;
    
    //load the items in a background thread
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        @autoreleasepool {
            NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"all" ofType:@"json"];
            NSData* data = [NSData dataWithContentsOfFile:jsonPath];
            NSError* error = nil;
            NSDictionary* object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"Error: %@", error.description);
            } else if (object != nil) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //this is the main UI thread
                    NSArray* items = object[@"data"];
                    NSInteger itemsAdded = 0;
                    for (NSInteger i = startItemIdx; i<items.count; ++i) {
                        StoreItem* si = [StoreItem itemWithDictionary:items[i]];
                        [self.storeItems addObject:si];
                        if (++itemsAdded >= _pageSize)
                            break;
                    }
                    NSLog(@"Items added: %ld", (long)itemsAdded);
                    [self.collectionView reloadData];
                }];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.storeItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //indexPath.item;
    if (indexPath.item < self.storeItems.count) {
        //Configure the cell
        if ([cell isKindOfClass:[StoreItemCollectionViewCell class]]) {
            StoreItemCollectionViewCell* sicell = (StoreItemCollectionViewCell*)cell;
            StoreItem* item = self.storeItems[indexPath.item];
            sicell.lblName.text = [NSString stringWithString:item.name];
            sicell.lblPrice.text = [NSString stringWithFormat:@" $%g ", [item.price doubleValue]];
            sicell.lblPrice.layer.cornerRadius = sicell.lblPrice.frame.size.height/2.0;
            sicell.lblPrice.layer.masksToBounds = YES;
            sicell.soldImageView.hidden = ![item.status isEqualToString:@"sold_out"];
            sicell.imageView.layer.cornerRadius = 10;
            sicell.imageView.layer.masksToBounds = YES;
            
            //load item photo
            NSData* imgData = self.imageCache[item.imageName];
            if (imgData != nil) {
                UIImage* image = [UIImage imageWithData:imgData];
                sicell.imageView.image = image;
            } else {
                //fetch image from remote server
                NSURL* url = [NSURL URLWithString:item.imageName];
                //NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
                //NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
                NSURLSession* session = [NSURLSession sharedSession];
                [[session dataTaskWithURL:url completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
                    if (error != nil) {
                        NSLog(@"Error loading photo: %@", error.description);
                    } else if (data != nil) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSData* curData = self.imageCache[item.imageName];
                            if (curData == nil) {
                                curData = data;
                                self.imageCache[item.imageName] = data;
                            }
                            UIImage* image = [UIImage imageWithData:data];
                            sicell.imageView.image = image;
                        }];
                    }
                }] resume];
            }
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.collectionView.contentOffset.y >= self.collectionView.contentSize.height - self.collectionView.bounds.size.height) {
        //scroll view was scrolled all the way to the bottom
        //so we need to load more data if present
        [self loadNextStoreItemsPage];
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.view.frame.size;
    size.width *= 0.33333333;
    size.height = size.width*225.0/184.0;
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
