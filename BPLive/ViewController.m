//
//  ViewController.m
//  BPLive
//
//  Created by LiHaozhen on 15/2/26.
//  Copyright (c) 2015年 ihojin. All rights reserved.
//

#import "ViewController.h"
#import "PathCollectionViewCell.h"
#import <CoreData/CoreData.h>
#import "CDLiveItem.h"
#import "AppDelegate.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIActionSheetDelegate>{
    
    
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UICollectionViewFlowLayout *_layout;
    
    NSIndexPath *_longPressIndexPath;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchRC;
@end

@implementation ViewController

- (NSFetchedResultsController *)fetchRC
{
    if (_fetchRC != nil) {
        return _fetchRC;
    }
    
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDLiveItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"rank" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchRC = theFetchedResultsController;
    _fetchRC.delegate = self;
    
    return _fetchRC;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [_collectionView performBatchUpdates:^{
        
        
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [_collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                break;
            case NSFetchedResultsChangeDelete:
                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                break;
            case NSFetchedResultsChangeMove:
                [_collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
            case NSFetchedResultsChangeUpdate:
                [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
                break;
                
            default:
                break;
        }
    } completion:^(BOOL finished) {
       
        
    }];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        
        NSManagedObject *obj = [self.fetchRC objectAtIndexPath:_longPressIndexPath];
        
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            
            UIViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPathViewController"];
            [editVC setValue:obj forKey:@"liveItem"];
            [self.navigationController pushViewController:editVC animated:YES];
        }else{
            
            
            [[AppDelegate sharedAppDelegate].managedObjectContext deleteObject:obj];
            [[AppDelegate sharedAppDelegate].managedObjectContext save:nil];
        }
    }
    _longPressIndexPath = nil;
}

- (void)gestureDidFired:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"删除"
                                               otherButtonTitles:@"编辑", nil];
        [ac showInView:self.navigationController.view];
        
        UICollectionViewCell *cell = (id)gesture.view;
        NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
        _longPressIndexPath = indexPath;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError *error = nil;
    [self.fetchRC performFetch:&error];
    if (error) {
        NSLog(@"error: %@", error);
        abort();
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchRC.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDLiveItem *item = [self.fetchRC objectAtIndexPath:indexPath];
    
    PathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.name = item.name;
    [cell setNeedsDisplay];
    
    UILongPressGestureRecognizer *_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDidFired:)];
    [cell addGestureRecognizer:_gesture];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL horizontal = NO;
    if (CGRectGetWidth(self.view.frame) > CGRectGetHeight(self.view.frame)) {
        horizontal = YES;
    }
    CGSize size;
    CGFloat viewWidth = self.view.frame.size.width - 8 * 2 - 4;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        size = CGSizeMake(viewWidth / (horizontal?6:4), 44);
    }else{
        size = CGSizeMake(viewWidth / (horizontal?4:2), 44);
    }
    
    return size;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UICollectionViewCell class]]) {
        NSIndexPath *indexPath = [_collectionView indexPathForCell:sender];
        CDLiveItem *item = [self.fetchRC objectAtIndexPath:indexPath];
        
        [segue.destinationViewController setValue:item.url forKey:@"url"];
    }
}
@end
