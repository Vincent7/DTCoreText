//
//  DTParagraphQuoteMarkObject.h
//  Pods
//
//  Created by Vincent on 2017/6/26.
//
//

#import <Foundation/Foundation.h>
#import "DTHTMLElement.h"
@interface DTParagraphQuoteMarkObject : NSObject
@property (nonatomic, readonly, copy) NSString *elementName;
@property (nonatomic, copy) NSString *elementIdentifer;
@property (nonatomic, strong) DTHTMLElement *element;
@property (nonatomic, assign) CGFloat elementLayoutOriginY;
@property (nonatomic, assign) NSRange elementRange;
-(DTParagraphQuoteMarkObject *)initWithElement:(DTHTMLElement *)element andIdentifer:(NSString *)elementIdentifer;
@end
