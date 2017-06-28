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

- (NSDictionary *_Nullable)generateParaMarksInfoWithOriginsInfo:(NSDictionary <NSString*, NSNumber*>*_Nullable)originsInfo andElementsInfo:(NSDictionary <NSString *,DTParagraphQuoteMarkObject *>* _Nullable)elementsInfo;{
    NSDictionary *paraMarksInfo;
    if (!elementsInfo) {
        paraMarksInfo = [NSDictionary dictionary];
    }else{
        paraMarksInfo = [elementsInfo copy];
    }
    
    [paraMarksInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DTParagraphQuoteMarkObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([originsInfo.allKeys containsObject:key]) {
            CGFloat paraMarkOriginY = [[originsInfo objectForKey:key] floatValue];
            DTParagraphQuoteMarkObject * paraMark = obj;
            paraMark.elementLayoutOriginY = paraMarkOriginY;
        }
    }];
    return paraMarksInfo;
}
@end
