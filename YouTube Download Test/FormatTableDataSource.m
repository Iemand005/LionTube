//
//  FormatTableController.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FormatTableDataSource.h"

@implementation FormatTableDataSource

- (id)init
{
    self = [super init];
    if (self) {
        formats = [NSMutableArray array];
    }
    return self;
}

- (void)addFormat:(NSDictionary *)format
{
    [formats addObject:format];
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationEffectFade];
//    [self.tableView reloadData];
//    [self.tableView needsDisplay];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return formats.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSDictionary *format = [formats objectAtIndex:row];
    NSTableCellView *cellView = [tableView viewAtColumn:0 row:row makeIfNecessary:YES];
    NSString *Q = [format objectForKey:@"mimeType"];
    if (!Q) Q = @"not found";
    [cellView.textField setStringValue:@"fart"];
    return Q;
}

//- ta

@end
