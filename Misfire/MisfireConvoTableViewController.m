//
//  MisfireConvoViewController.m
//  Misfire
//
//  Created by Justin Boogaard on 4/5/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "MisfireConvoTableViewController.h"
#import "SimpleTableCellTableViewCell.h"

@implementation MisfireConvoTableViewController

{
    NSMutableArray *tableData;
    NSMutableArray *thumbnails;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    tableData = [NSMutableArray arrayWithObjects:@"Baby I love you",@"i can't wait to be big spoon",@"you... wanna be big spoon?",@"I just want to provide love and support to my fragile flower", @"fragile flower? girl... who do you think i am?",@"what do you mean girl?", @"what do you mean what do i mean?", @"look vanessa... i don't know what you're into but...",@"vanessa? my name is Tomas.", nil];
    
thumbnails = [NSMutableArray arrayWithObjects:@"egg_benedict.jpg", @"mushroom_risotto.jpg", @"full_breakfast.jpg", @"hamburger.jpg", @"ham_and_egg_sandwich.jpg", @"creme_brelee.jpg", @"white_chocolate_donut.jpg", @"starbucks_coffee.jpg", @"vegetable_curry.jpg", @"instant_noodle_with_egg.jpg", @"noodle_with_bbq_pork.jpg", @"japanese_noodle_with_pork.jpg", @"green_tea.jpg", @"thai_shrimp_cake.jpg", @"angry_birds_cake.jpg", @"ham_and_cheese_panini.jpg", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableData: %lu", (unsigned long)tableData.count);
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

@end
