//
//  DTParagraphMarkManager.h
//  DTCoreText
//
//  Created by Vincent on 2017/6/28.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTParagraphQuoteMarkObject.h"
@interface DTParagraphMarkManager : NSObject

- (void) updateParaMarksInfoWithDictionary:(NSDictionary <NSString *,DTParagraphQuoteMarkObject *>*_Nonnull)paraMarksInfo;

- (DTParagraphQuoteMarkObject *_Nullable)getParaMarkWithIdentifer:(NSString * _Nonnull)identifer;
- (CGFloat)getParaOriginYWithIdentifer:(NSString * _Nonnull)identifer;
- (DTParagraphMarkManager *_Nonnull)initWithParaMarks:(NSDictionary <NSString *,DTParagraphQuoteMarkObject *>*_Nonnull)paraMarksInfo;

- (NSDictionary *_Nullable)generateParaMarksInfoWithOriginsInfo:(NSDictionary <NSString*, NSNumber*>*_Nullable)originsInfo andElementsInfo:(NSDictionary <NSString *,DTParagraphQuoteMarkObject *>* _Nullable)elementsInfo;
@end
