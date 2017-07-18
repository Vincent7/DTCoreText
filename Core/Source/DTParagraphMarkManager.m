//
//  DTParagraphMarkManager.m
//  DTCoreText
//
//  Created by Vincent on 2017/6/28.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import "DTParagraphMarkManager.h"
@interface DTParagraphMarkManager()
@property (nonatomic, strong) NSDictionary<NSString *,DTParagraphQuoteMarkObject *> *paraMarksInfo;
@end
@implementation DTParagraphMarkManager
- (void) updateParaMarksInfoWithDictionary:(NSDictionary <NSString *,DTParagraphQuoteMarkObject *>*_Nonnull)paraMarksInfo{
    self.paraMarksInfo = paraMarksInfo;
}
-(DTParagraphMarkManager *)initWithParaMarks:(NSDictionary<NSString *,DTParagraphQuoteMarkObject *> *)paraMarksInfo{
	self = [super init];
	if (self) {
		self.paraMarksInfo = paraMarksInfo;
	}
	return self;
}
-(CGFloat)getParaOriginYWithIdentifer:(NSString * _Nonnull)identifer{
	DTParagraphQuoteMarkObject* markObject = [self getParaMarkWithIdentifer:identifer];
	if (markObject) {
		return markObject.elementLayoutOriginY;
	}
	return 0;
}
-(NSRange)getParaLocationRangeWithIdentifer:(NSString * _Nonnull)identifer{
    DTParagraphQuoteMarkObject* markObject = [self getParaMarkWithIdentifer:identifer];
    if (markObject) {
        return markObject.elementRange;
    }
    return NSMakeRange(0, 0);
}
-(DTParagraphQuoteMarkObject *)getParaMarkWithIdentifer:(NSString * _Nonnull)identifer{
	if ([self.paraMarksInfo.allKeys containsObject:identifer]) {
		DTParagraphQuoteMarkObject *markObject = [self.paraMarksInfo objectForKey:identifer];
		return markObject;
	}
	return nil;
}
-(NSDictionary<NSString *,DTParagraphQuoteMarkObject *> *)paraMarksInfo{
	if (!_paraMarksInfo) {
		_paraMarksInfo = [NSDictionary dictionary];
	}
	return _paraMarksInfo;
}

- (NSDictionary *_Nullable)generateParaMarksInfoWithOriginsInfo:(NSDictionary <NSString*, NSNumber*>*_Nullable)originsInfo andParaLocationsInfo:(NSDictionary <NSString*, NSValue*>*_Nullable)locationsInfo andElementsInfo:(NSDictionary <NSString *,DTParagraphQuoteMarkObject *>* _Nullable)elementsInfo;{
    NSDictionary *paraMarksInfo;
    if (!elementsInfo) {
        paraMarksInfo = [NSDictionary dictionary];
    }else{
        paraMarksInfo = [elementsInfo copy];
    }
    
    [paraMarksInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DTParagraphQuoteMarkObject * _Nonnull obj, BOOL * _Nonnull stop) {
        DTParagraphQuoteMarkObject * paraMark = obj;
        if ([originsInfo.allKeys containsObject:key]) {
            CGFloat paraMarkOriginY = [[originsInfo objectForKey:key] floatValue];
            paraMark.elementLayoutOriginY = paraMarkOriginY;
        }
        if ([locationsInfo.allKeys containsObject:key]) {
            NSRange paraRange = [[locationsInfo objectForKey:key] rangeValue];
            paraMark.elementRange = paraRange;
        }
    }];
    return paraMarksInfo;
}
@end
