//
//  AddPathViewController.m
//  BPLive
//
//  Created by LiHaozhen on 15/2/26.
//  Copyright (c) 2015年 ihojin. All rights reserved.
//

#import "AddPathViewController.h"
#import "AppDelegate.h"
#import "CDLiveItem.h"

@interface AddPathViewController (){
    
    IBOutlet UITextField *_nameTf;
    IBOutlet UITextView *_pathTv;
    IBOutlet UIBarButtonItem *_saveItem;
}

- (IBAction)toSave:(id)sender;
@end

@implementation AddPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:_nameTf];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:_pathTv];
    
    [self textChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.liveItem) {
        _nameTf.text = self.liveItem.name;
        _pathTv.text = self.liveItem.url;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_nameTf becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChanged
{
    if (_nameTf.text.length && _pathTv.text.length) {
        
        _saveItem.enabled = YES;
    }else{
        
        _saveItem.enabled = NO;
    }
}

- (IBAction)toSave:(id)sender {
    
    if (self.liveItem) {
        
        self.liveItem.name = _nameTf.text;
        self.liveItem.url = _pathTv.text;
        NSError *error = nil;
        [self.liveItem.managedObjectContext save:&error];
        if (error) {
            NSLog(@"error: %@", error);
            abort();
        }
    }else{
     
        NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDLiveItem"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
        // [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"error: %@", error);
            abort();
        }else{
            
            CDLiveItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"CDLiveItem" inManagedObjectContext:context];
            item.rank = @(fetchedObjects.count);
            item.name = _nameTf.text;
            item.url = _pathTv.text;
            
            NSError *error = nil;
            [context save:&error];
            if (error) {
                NSLog(@"error: %@", error);
                abort();
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
