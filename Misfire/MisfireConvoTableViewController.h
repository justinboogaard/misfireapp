//
//  MisfireConvoViewController.h
//  Misfire
//
//  Created by Justin Boogaard on 4/5/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MisfireConvoTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;



@end
