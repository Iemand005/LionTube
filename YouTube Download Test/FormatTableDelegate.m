//
//  FormatTableDelegate.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FormatTableDelegate.h"

@implementation FormatTableDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];//[tableView viewAtColumn:0 row:row makeIfNecessary:YES];
    NSString *value = [tableView.dataSource tableView:tableView objectValueForTableColumn:tableColumn row:row];
    [cellView.textField setStringValue:value];
    return cellView;
}

@end
