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

- (void)addFormat:(LVideoFormat *)format
{
    [formats addObject:format];
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationEffectFade];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return formats.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    LVideoFormat *format = [formats objectAtIndex:row];
    return format.mimeType;
}

//- ta

@end
