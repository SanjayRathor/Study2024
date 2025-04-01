//
//  ViewController.m
//  SAAlogos
//
//  Created by Sanjay Singh Rathor on 30/11/20.
//

#import "ViewController.h"
#import "NSArray+BinarySearch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    for (NSInteger index = 1; index <=100; index++) {
        [items addObject:@(index)];
    }
   // NSArray *items = @[@10, @20, @30, @40, @50, @60, @70, @80, @90];
    NSLog(@"found %ld", (long)[items binarySearch:@2]);
    return;
    
    int n=6, sum=0, i;
    for(i=1;i<=n;i++) {
        sum=sum+i;
    }
    
    NSLog(@"found %ld", (long)[self linerSearch: 10]);
    NSLog(@"found %ld", (long)[self linerSearch: 100]);
    NSLog(@"found %ld", (long)[self linerSearch: 50]);
    
    
    [self sum:n];
}

- (void)sum:(NSInteger)num {
    
    NSInteger value = num*(num+1)/2;
    NSLog(@"Natural Number - %ld", (long)value);
}

- (NSInteger)linerSearch:(NSInteger)searchNumber {
    NSArray *items = @[@10, @20, @30, @40, @50, @15, @25, @17];
    
    for (NSInteger index=0; index< [items count]; index++ ) {
        if (searchNumber  ==  [items[index] intValue]) {
            return  index;
        }
    }
    
    return -1;
    
}



@end
