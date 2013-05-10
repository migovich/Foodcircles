//
//  FCSVenueListViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueListViewController.h"

#import "FCSRemoteAPI.h"
#import "FCSAppDelegate.h"
#import "FCSVenueViewController.h"
#import "FCSVenue.h"
#import "FCSSpecial.h"
#import "FCSVenueCell.h"

NSString *kVenueId = @"venueListViewID";

@interface FCSVenueListViewController ()

@end

@implementation FCSVenueListViewController

@synthesize fetchedResultsController;


- (void)viewDidLoad
{
  [super viewDidLoad];
  [FCSRemoteAPI loadVenues];

  // Force the load immediately. Move later if perforamnce issues
  NSError *e;
  [self.fetchedResultsController performFetch:&e];
  
  self.collectionView.backgroundColor = [UIColor colorWithRed:0.9375 green:0.910156 blue:0.86718 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  if ([segue.identifier isEqualToString:@"showVenue"]) {
//    NSIndexPath *indexPath = [self.collectionView indexPathForSelectedRow];
//    FCSVenue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    FCSVenueViewController *destinationViewController = (FCSVenueViewController *)segue.destinationViewController;
//    destinationViewController.venue = venue;
//    destinationViewController.title = venue.name;
//  }
}


#pragma mark -
#pragma mark UICollectionViewDataSoure

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSArray *sections = [self.fetchedResultsController sections];
  id<NSFetchedResultsSectionInfo> sectionInfo = nil;
  sectionInfo = [sections objectAtIndex:section];
  return sectionInfo.numberOfObjects;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FCSVenue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
  FCSVenueCell *venueCell = [collectionView dequeueReusableCellWithReuseIdentifier:kVenueId forIndexPath:indexPath];
  venueCell.productImage.image = venue.thumbnail;
  venueCell.productName.text = [venue.name uppercaseString];
  venueCell.detailTextLabel.text = venue.foodType;
  return venueCell;
}

#pragma mark -
#pragma mark UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return [[self.fetchedResultsController sections] count];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  NSArray *sections = [self.fetchedResultsController sections];
//  id<NSFetchedResultsSectionInfo> sectionInfo = nil;
//  sectionInfo = [sections objectAtIndex:section];
//  return sectionInfo.numberOfObjects;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  UITableViewCell *venueCell = nil;
//  FCSVenue *venue = nil;
//  venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//  venueCell = [self.collectionView dequeueReusableCellWithIdentifier:@"VenueTableCell"];
//  venueCell.textLabel.text = venue.name;
//  venueCell.detailTextLabel.text = venue.foodType;
//  venueCell.imageView.image = venue.thumbnail;
//  return venueCell;
//}


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
  // Set up the fetched results controller if needed.
  if (!fetchedResultsController) {
    NSManagedObjectContext *managedObjectContext = ( (FCSAppDelegate *)[UIApplication sharedApplication].delegate ).managedObjectContext;
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
  }
	
	return fetchedResultsController;
}

@end