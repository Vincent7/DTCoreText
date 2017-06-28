#import "DTCoreTextConstants.h"

// standard options

#if TARGET_OS_IPHONE
NSString * const NSBaseURLDocumentOption = @"NSBaseURLDocumentOption";
NSString * const NSTextEncodingNameDocumentOption = @"NSTextEncodingNameDocumentOption";
NSString * const NSTextSizeMultiplierDocumentOption = @"NSTextSizeMultiplierDocumentOption";

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
NSString * const NSAttachmentAttributeName = @"NSAttachmentAttributeName";
#endif

#endif

// custom options

NSString * const DTMaxImageSize = @"DTMaxImageSize";
NSString * const DTDefaultFontFamily = @"DTDefaultFontFamily";
NSString * const DTDefaultFontName = @"DTDefaultFontName";
NSString * const DTDefaultFontSize = @"DTDefaultFontSize";
NSString * const DTDefaultTextColor = @"DTDefaultTextColor";
NSString * const DTDefaultLinkColor = @"DTDefaultLinkColor";
NSString * const DTDefaultLinkHighlightColor = @"DTDefaultLinkHighlightColor";
NSString * const DTDefaultLinkDecoration = @"DTDefaultLinkDecoration";
NSString * const DTDefaultTextAlignment = @"DTDefaultTextAlignment";
NSString * const DTDefaultLineHeightMultiplier = @"DTDefaultLineHeightMultiplier";
NSString * const DTDefaultFirstLineHeadIndent = @"DTDefaultFirstLineHeadIndent";
NSString * const DTDefaultHeadIndent = @"DTDefaultHeadIndent";
NSString * const DTDefaultStyleSheet = @"DTDefaultStyleSheet";
NSString * const DTUseiOS6Attributes = @"DTUseiOS6Attributes";
NSString * const DTWillFlushBlockCallBack = @"DTWillFlushBlockCallBack";
NSString * const DTProcessCustomHTMLAttributes = @"DTProcessCustomHTMLAttributes";
NSString * const DTIgnoreInlineStylesOption = @"DTIgnoreInlineStyles";
NSString * const DTDocumentPreserveTrailingSpaces = @"DTDocumentPreserveTrailingSpaces";
// custom paragraph style attribute
NSString * const DTCoreTextCustomParagraphStyleInfo = @"DTCoreTextCustomParagraphStyleInfo";

// attributed string attribute constants

NSString * const DTTextListsAttribute = @"DTTextLists";
NSString * const DTAttachmentParagraphSpacingAttribute = @"DTAttachmentParagraphSpacing";
NSString * const DTLinkAttribute = @"NSLink";
NSString * const DTLinkHighlightColorAttribute = @"DTLinkHighlightColor";
NSString * const DTAnchorAttribute = @"DTAnchor";
NSString * const DTGUIDAttribute = @"DTGUID";
NSString * const DTHeaderLevelAttribute = @"DTHeaderLevel";
NSString * const DTStrikeOutAttribute = @"DTStrikethrough";
NSString * const DTBackgroundColorAttribute = @"DTBackgroundColor";
NSString * const DTShadowsAttribute = @"DTShadows";
NSString * const DTHorizontalRuleStyleAttribute = @"DTHorizontalRuleStyle";
NSString * const DTTextBlocksAttribute = @"DTTextBlocks";
NSString * const DTFieldAttribute = @"DTField";
NSString * const DTCustomAttributesAttribute = @"DTCustomAttributes";
NSString * const DTAscentMultiplierAttribute = @"DTAscentMultiplierAttribute";
NSString * const DTBackgroundStrokeColorAttribute = @"DTBackgroundStrokeColor";
NSString * const DTBackgroundStrokeWidthAttribute = @"DTBackgroundStrokeWidth";
NSString * const DTBackgroundCornerRadiusAttribute = @"DTBackgroundCornerRadius";

NSString * const DTVJParagraphIdentiferName = @"DTVJParagraphIdentiferName";
// field constants
NSString * const DTListPrefixField = @"{listprefix}";

// iOS 6 compatibility

BOOL ___useiOS6Attributes = NO; // this gets set globally by DTHTMLAttributedStringBuilder


// exceptions

NSString * const DTCoreTextFontDescriptorException = @"DTCoreTextFontDescriptorException";

NSString * const TKSCustomParaStyleFirstLineHeadIndent;


/**
 The document-wide default tab interval.
 
 The default tab interval in points. Tabs after the last specified in tabStops are placed at integer multiples of this distance (if positive). Default return value is 0.0.
 */
NSString * const TKSCustomParaStyleTabInterval = @"TKSCustomParaStyleTabInterval";


/**
 The distance between the paragraph’s top and the beginning of its text content.
 */
NSString * const TKSCustomParaStyleParagraphSpacingBefore = @"TKSCustomParaStyleParagraphSpacingBefore";


/**
 The space after the end of the paragraph.
 */
NSString * const TKSCustomParaStyleParagraphSpacing = @"TKSCustomParaStyleParagraphSpacing";


/**
 The line height multiple.
 
 Internally line height multiples get converted into minimum and maximum line height.
 */
NSString * const TKSCustomParaStyleLineHeightMultiple = @"TKSCustomParaStyleLineHeightMultiple";

NSString * const TKSCustomParaStyleTextColorHex = @"TKSCustomParaStyleTextColorHex";
NSString * const TKSCustomParaStyleFontName = @"TKSCustomParaStyleFontName";
NSString * const TKSCustomParaStyleFontSize = @"TKSCustomParaStyleFontSize";

/**
 The minimum height in points that any line in the receiver will occupy, regardless of the font size or size of any attached graphic. This value is always nonnegative.
 */
NSString * const TKSCustomParaStyleMinimumLineHeight = @"TKSCustomParaStyleMinimumLineHeight";


/**
 The maximum height in points that any line in the receiver will occupy, regardless of the font size or size of any attached graphic. This value is always nonnegative. The default value is 0.
 */
NSString * const TKSCustomParaStyleMaximumLineHeight = @"TKSCustomParaStyleMaximumLineHeight";


/**
 The distance in points from the margin of a text container to the end of lines.
 
 @note This value is negative if it is to be measured from the trailing margin, positive if measured from the same margin as the headIndent.
 */
NSString * const TKSCustomParaStyleTailIndent = @"TKSCustomParaStyleTailIndent";

/**
 The distance in points from the leading margin of a text container to the beginning of lines other than the first. This value is always nonnegative.
 */
NSString * const TKSCustomParaStyleHeadIndent = @"TKSCustomParaStyleHeadIndent";

/**
 The text alignment of the receiver.
 
 Natural text alignment is realized as left or right alignment depending on the line sweep direction of the first script contained in the paragraph.
 */
NSString * const TKSCustomParaStyleAlignment = @"TKSCustomParaStyleAlignment";


/**
 The base writing direction for the receiver.
 
 */
NSString * const TKSCustomParaStyleBaseWritingDirection = @"TKSCustomParaStyleBaseWritingDirection";
