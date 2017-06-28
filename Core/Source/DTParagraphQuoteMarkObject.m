//
//  DTParagraphQuoteMarkObject.m
//  Pods
//
//  Created by Vincent on 2017/6/26.
//
//

#import "DTParagraphQuoteMarkObject.h"

@implementation DTParagraphQuoteMarkObject
-(DTParagraphQuoteMarkObject *)initWithElement:(DTHTMLElement *)element andIdentifer:(NSString *)elementIdentifer{
    self = [super init];
    if (self) {
        _elementName = element.name;
        _element = element;
        _elementIdentifer = elementIdentifer;
    }
    return self;
}
@end
