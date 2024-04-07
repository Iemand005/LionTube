//
//  FormatTableController.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatTableDataSource : NSObject <NSTableViewDataSource>
{
    NSMutableArray *formats;
}
@property IBOutlet NSTableView *tableView;
- (void)addFormat:(NSDictionary *)format;

@end
