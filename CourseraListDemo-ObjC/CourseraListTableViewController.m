//
//  ViewController.m
//  CourseraListDemo-ObjC
//
//  Created by Ancil on 7/13/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//
//  Hello from horla
#import "CourseraListTableViewController.h"
#import "CourseListTableViewCell.h"

static NSString* const NFPServerScheme = @"https";
static NSString* const NFPServerHost = @"api.coursera.org";
static NSString* const NFPServerPath = @"/api/catalog.v1/";
static NSString* const kCourseListTableViewCellIdentifier = @"cell";


#if 1 && defined(DEBUG)
#define LOG(format, ...) NSLog(@"Course List TVC: " format, ## __VA_ARGS__)
#else
#define LOG(format, ...)
#endif

@interface CourseraListTableViewController ()
@property (nonatomic,strong) NSArray* courses; // array of dictionaries
@end

@implementation CourseraListTableViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // FIXME: Replace NSData dataWithContentsOfURL method with NSURLSession
    
    NSString* endpoint = @"courses";
    NSArray* queryItems = [self queryItemsForQueryNames:@[@"fields"]];
    NSURL* url = [self NSURLFromEndpoint:endpoint queryItems:queryItems];
    
    LOG(@"URL: %@",url);
    
    NSData* coursesData = [NSData dataWithContentsOfURL:url];
    NSError* jsonError;
    NSDictionary* coursesDict = [NSJSONSerialization JSONObjectWithData:coursesData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&jsonError];
    
    self.courses = coursesDict[@"elements"]; //Array of Dictionaries
    
    //register table view nib. Need to perform here so that custom cell can be dequeued
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseListTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:kCourseListTableViewCellIdentifier];
    
    
}

// Simple list of course fields of interest
-(NSArray*)courseFields;
{
    return @[
             @"id", //Int
             @"shortName", //String
             @"name", //String
             @"language",//String
             @"largeIcon", // Option[String]
             @"photo", //Option[String]
             @"smallIcon"]; //Option[String]
}


#pragma mark - API URL Construction Methods
-(NSArray*)queryItemsForQueryNames:(NSArray*)queryNames;
{
    //create queryItems; queryItemsForQueryNames
    NSMutableArray* queryItems = [NSMutableArray new];
    for (NSString* queryName in queryNames){
        NSString* queryValue = [self queryValueForName:queryName];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:queryName value:queryValue]];
    }
    return queryItems;
}

-(NSURL*)NSURLFromEndpoint:(NSString*)endpoint queryItems:(NSArray*)queryItems;
{
    
    NSURLComponents* components = [[NSURLComponents alloc] init];
    components.scheme = NFPServerScheme;
    components.host = NFPServerHost;
    components.path = [NFPServerPath stringByAppendingString:endpoint];
    components.queryItems = queryItems;
    
    return  components.URL;
}

-(NSString*)queryValueForName:(NSString*)queryName;
{
    
    NSString* str;
    
    if ( [queryName isEqualToString:@"fields"]){
        NSArray* fieldQueries = [self courseFields];
        str = [fieldQueries componentsJoinedByString:@","];
    }
    
    return str;
}

#pragma mark - Table View Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.courses count];
}

-(CourseListTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CourseListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCourseListTableViewCellIdentifier];
    
    if (![cell isKindOfClass:[CourseListTableViewCell class]]){
        [tableView registerNib:[UINib nibWithNibName:@"CourseListTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:kCourseListTableViewCellIdentifier];
        //cell = [tableView dequeueReusableCellWithIdentifier:kCourseListTableViewCellIdentifier];
        
        cell = [[CourseListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCourseListTableViewCellIdentifier];
    }
    
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString:self.courses[indexPath.row][@"largeIcon"]]];
    UIImage* image = [UIImage imageWithData:data];
    
    
    cell.customImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.customImageView.clipsToBounds = YES;
    cell.customImageView.image = image;
    cell.title.text = self.courses[indexPath.row][@"name"];
    return cell;
}


@end
