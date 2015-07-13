//
//  ViewController.m
//  CourseraListDemo-ObjC
//
//  Created by Ancil on 7/13/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "CourseraListTableViewController.h"
#import "CourseListTableViewCell.h"

static NSString* const NFPServerScheme = @"https";
static NSString* const NFPServerHost = @"api.coursera.org";
static NSString* const NFPServerPath = @"/api/catalog.v1/";
static NSString* const kCourseListTableViewCellIdentifier = @"cell";

@interface CourseraListTableViewController ()
@property (nonatomic,strong) NSArray* courses; // array of dictionaries
@end

@implementation CourseraListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* endpoint = @"courses";
    
    //create queryItems; queryItemsForQueryNames
    NSArray* queryNames = @[@"fields"];
    NSMutableArray* queryItems = [NSMutableArray new];
    for (NSString* queryName in queryNames){
        NSString* queryValue = [self queryValueForName:queryName];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:queryName value:queryValue]];
    }
    
    NSURL* url = [self NSURLFromEndpoint:endpoint queryItems:queryItems];
    NSData* coursesData = [NSData dataWithContentsOfURL:url];
    NSError* jsonError;
    NSDictionary* coursesDict = [NSJSONSerialization JSONObjectWithData:coursesData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&jsonError];
    
    self.courses = coursesDict[@"elements"]; //Array of Dictionaries
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseListTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:kCourseListTableViewCellIdentifier];
    
    
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

//MARK: - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.courses count];
}



@end
