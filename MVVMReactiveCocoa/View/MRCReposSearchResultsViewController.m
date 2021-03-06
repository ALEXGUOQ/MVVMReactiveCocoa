//
//  MRCReposSearchResultsViewController.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/5/10.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import "MRCReposSearchResultsViewController.h"
#import "MRCReposSearchResultsViewModel.h"
#import "MRCReposTableViewCell.h"
#import "MRCReposSearchResultsItemViewModel.h"
#import "UIImage+RTTint.h"

@interface MRCReposSearchResultsViewController ()

@property (strong, nonatomic, readonly) MRCReposSearchResultsViewModel *viewModel;
@property (strong, nonatomic) UIImage *unstarImage;
@property (strong, nonatomic) UIImage *starImage;
@end

@implementation MRCReposSearchResultsViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.unstarImage = [UIImage octicon_imageWithIdentifier:@"Star" size:CGSizeMake(12, 12)];
    self.starImage   = [self.unstarImage rt_tintedImageWithColor:HexRGB(colorI5)];
}

- (NSString *)labelText {
    return @"Searching";
}

- (void)configureCell:(MRCReposTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(MRCReposSearchResultsItemViewModel *)viewModel {
    [super configureCell:cell atIndexPath:indexPath withObject:viewModel];
    
    [[[RACObserve(viewModel.repository, isStarred)
        distinctUntilChanged]
        deliverOnMainThread]
        subscribeNext:^(NSNumber *isStarred) {
             if (isStarred.boolValue) {
                 cell.starIconImageView.image = self.starImage;
             } else {
                 cell.starIconImageView.image = self.unstarImage;
             }
         }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.viewModel.query = searchText;
    self.viewModel.dataSource = nil;
    self.viewModel.shouldDisplayEmptyDataSet = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        [self.viewModel.requestRemoteDataCommand execute:nil];
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"No Results"];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    MRCReposSearchResultsItemViewModel *viewModel = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if ([viewModel.repository.ownerLogin isEqualToString:[OCTUser mrc_currentUser].login]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UITableViewDelegate

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRCReposSearchResultsItemViewModel *viewModel = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (viewModel.repository.isStarred) {
        void (^handler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            tableView.editing = false;
            
            MRCReposItemViewModel *viewModel = self.viewModel.dataSource[indexPath.section][indexPath.row];
            [[[self.viewModel.services client] mrc_unstarRepository:viewModel.repository] subscribeNext:^(id x) {}];
        };
        
        UITableViewRowAction *unstarAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                title:@"Unstar"
                                                                              handler:handler];
        return @[ unstarAction ];
    } else {
        void (^handler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            tableView.editing = false;
            
            MRCReposItemViewModel *viewModel = self.viewModel.dataSource[indexPath.section][indexPath.row];
            [[[self.viewModel.services client] mrc_starRepository:viewModel.repository] subscribeNext:^(id x) {}];
        };
        
        UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                              title:@"Star"
                                                                            handler:handler];
        return @[ starAction ];
    }
}

@end
