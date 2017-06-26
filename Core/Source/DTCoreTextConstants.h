// unicode characters

#define UNICODE_OBJECT_PLACEHOLDER @"\ufffc"
#define UNICODE_LINE_FEED @"\u2028"

// unicode spaces (see http://www.cs.tut.fi/~jkorpela/chars/spaces.html)

#define UNICODE_SPACE @"\u0020"
#define UNICODE_NON_BREAKING_SPACE @"\u00a0"
#define UNICODE_OGHAM_SPACE_MARK @"\u1680"
#define UNICODE_MONGOLIAN_VOWEL_SEPARATOR @"\u180e"
#define UNICODE_EN_QUAD @"\u2000"
#define UNICODE_EM_QUAD @"\u2001"
#define UNICODE_EN_SPACE @"\u2002"
#define UNICODE_EM_SPACE @"\u2003"
#define UNICODE_THREE_PER_EM_SPACE @"\u2004"
#define UNICODE_FOUR_PER_EM_SPACE @"\u2005"
#define UNICODE_SIX_PER_EM_SPACE @"\u2006"
#define UNICODE_FIGURE_SPACE @"\u2007"
#define UNICODE_PUNCTUATION_SPACE @"\u2008"
#define UNICODE_THIN_SPACE @"\u2009"
#define UNICODE_HAIR_SPACE @"\u200a"
#define UNICODE_ZERO_WIDTH_SPACE @"\u200b"
#define UNICODE_NARROW_NO_BREAK_SPACE @"\u202f"
#define UNICODE_MEDIUM_MATHEMATICAL_SPACE @"\u205f"
#define UNICODE_IDEOGRAPHIC_SPACE @"\u3000"
#define UNICODE_ZERO_WIDTH_NO_BREAK_SPACE @"\ufeff"

// standard options

#if TARGET_OS_IPHONE
extern NSString * const NSBaseURLDocumentOption;
extern NSString * const NSTextEncodingNameDocumentOption;
extern NSString * const NSTextSizeMultiplierDocumentOption;

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
extern NSString * const NSAttachmentAttributeName; 
#endif

#endif

// custom options

extern NSString * const DTMaxImageSize;
extern NSString * const DTDefaultFontFamily;
extern NSString * const DTDefaultFontName;
extern NSString * const DTDefaultFontSize;
extern NSString * const DTDefaultTextColor;
extern NSString * const DTDefaultLinkColor;
extern NSString * const DTDefaultLinkDecoration;
extern NSString * const DTDefaultLinkHighlightColor;
extern NSString * const DTDefaultTextAlignment;
extern NSString * const DTDefaultLineHeightMultiplier;
extern NSString * const DTDefaultLineHeightMultiplier;
extern NSString * const DTDefaultFirstLineHeadIndent;
extern NSString * const DTDefaultHeadIndent;
extern NSString * const DTDefaultStyleSheet;
extern NSString * const DTUseiOS6Attributes;
extern NSString * const DTWillFlushBlockCallBack;
extern NSString * const DTProcessCustomHTMLAttributes;
extern NSString * const DTIgnoreInlineStylesOption;
extern NSString * const DTDocumentPreserveTrailingSpaces;
extern NSString * const DTCoreTextCustomParagraphStyleInfo;

// attributed string attribute constants

extern NSString * const DTTextListsAttribute;
extern NSString * const DTAttachmentParagraphSpacingAttribute;
extern NSString * const DTLinkAttribute;
extern NSString * const DTLinkHighlightColorAttribute;
extern NSString * const DTAnchorAttribute;
extern NSString * const DTGUIDAttribute;
extern NSString * const DTHeaderLevelAttribute;
extern NSString * const DTStrikeOutAttribute;
extern NSString * const DTBackgroundColorAttribute;
extern NSString * const DTShadowsAttribute;
extern NSString * const DTHorizontalRuleStyleAttribute;
extern NSString * const DTTextBlocksAttribute;
extern NSString * const DTFieldAttribute;
extern NSString * const DTCustomAttributesAttribute;
extern NSString * const DTAscentMultiplierAttribute;
extern NSString * const DTBackgroundStrokeColorAttribute;
extern NSString * const DTBackgroundStrokeWidthAttribute;
extern NSString * const DTBackgroundCornerRadiusAttribute;

// field constants

extern NSString * const DTListPrefixField;

// iOS 6 compatibility
extern BOOL ___useiOS6Attributes;

// exceptions
extern NSString * const DTCoreTextFontDescriptorException;


extern NSString * const TKSCustomParaStyleFirstLineHeadIndent;


/**
 The document-wide default tab interval.
 
 The default tab interval in points. Tabs after the last specified in tabStops are placed at integer multiples of this distance (if positive). Default return value is 0.0.
 */
extern NSString * const TKSCustomParaStyleTabInterval;


/**
 The distance between the paragraph’s top and the beginning of its text content.
 */
extern NSString * const TKSCustomParaStyleParagraphSpacingBefore;


/**
 The space after the end of the paragraph.
 */
extern NSString * const TKSCustomParaStyleParagraphSpacing;


/**
 The line height multiple.
 
 Internally line height multiples get converted into minimum and maximum line height.
 */
extern NSString * const TKSCustomParaStyleLineHeightMultiple;


/**
 The minimum height in points that any line in the receiver will occupy, regardless of the font size or size of any attached graphic. This value is always nonnegative.
 */
extern NSString * const TKSCustomParaStyleMinimumLineHeight;


/**
 The maximum height in points that any line in the receiver will occupy, regardless of the font size or size of any attached graphic. This value is always nonnegative. The default value is 0.
 */
extern NSString * const TKSCustomParaStyleMaximumLineHeight;


/**
 The distance in points from the margin of a text container to the end of lines.
 
 @note This value is negative if it is to be measured from the trailing margin, positive if measured from the same margin as the headIndent.
 */
extern NSString * const TKSCustomParaStyleTailIndent;

/**
 The distance in points from the leading margin of a text container to the beginning of lines other than the first. This value is always nonnegative.
 */
extern NSString * const TKSCustomParaStyleHeadIndent;

/**
 The text alignment of the receiver.
 
 Natural text alignment is realized as left or right alignment depending on the line sweep direction of the first script contained in the paragraph.
 */
extern NSString * const TKSCustomParaStyleAlignment;

extern NSString * const TKSCustomParaStyleTextColorHex;
extern NSString * const TKSCustomParaStyleFontName;
extern NSString * const TKSCustomParaStyleFontSize;
/**
 The base writing direction for the receiver.
 
 */
extern NSString * const TKSCustomParaStyleBaseWritingDirection;
// macros

#define IS_WHITESPACE(_c) (_c == ' ' || _c == '\t' || _c == 0xA || _c == 0xB || _c == 0xC || _c == 0xD || _c == 0x85)

// types

/**
 DTHTMLElement display style
 */
typedef NS_ENUM(NSUInteger, DTHTMLElementDisplayStyle)
{
	/**
	 The element is inline text
	 */
	DTHTMLElementDisplayStyleInline = 0, // default
	
	/**
	 The element is not displayed
	 */
	DTHTMLElementDisplayStyleNone,
	
	/**
	 The element is a block
	 */
	DTHTMLElementDisplayStyleBlock,
	
	/**
	 The element is an item in a list
	 */
	DTHTMLElementDisplayStyleListItem,
	
	/**
	 The element is a table
	 */
	DTHTMLElementDisplayStyleTable,
};

/**
 DTHTMLElement floating style
 */
typedef NS_ENUM(NSUInteger, DTHTMLElementFloatStyle)
{
	/**
	 The element does not float
	 */
	DTHTMLElementFloatStyleNone = 0,
	
	
	/**
	 The element should float left-aligned
	 */
	DTHTMLElementFloatStyleLeft,
	
	
	/**
	 The element should float right-aligned
	 */
	DTHTMLElementFloatStyleRight
};

/**
 DTHTMLElement font variants
 */
typedef NS_ENUM(NSUInteger, DTHTMLElementFontVariant)
{
	/**
	 The element inherits the font variant
	 */
	DTHTMLElementFontVariantInherit = 0,
	
	/**
	 The element uses the normal font variant
	 */
	DTHTMLElementFontVariantNormal,
	
	/**
	 The element should display in small caps
	 */
	DTHTMLElementFontVariantSmallCaps
};

/**
 The algorithm that DTCoreTextLayoutFrame uses for positioning lines
 */
typedef NS_ENUM(NSUInteger, DTCoreTextLayoutFrameLinePositioningOptions)
{
	/**
	 The line positioning algorithm is similar to how Safari positions lines
	 */
	DTCoreTextLayoutFrameLinePositioningOptionAlgorithmWebKit = 1,
	
	/**
	 The line positioning algorithm is how it was before the implementation of DTCoreTextLayoutFrameLinePositioningOptionAlgorithmWebKit
	 */
	DTCoreTextLayoutFrameLinePositioningOptionAlgorithmLegacy = 2
};

// layouting

// the value to use if the width is unknown
#define CGFLOAT_WIDTH_UNKNOWN 16777215.0f

// the value to use if the height is unknown
#define CGFLOAT_HEIGHT_UNKNOWN 16777215.0f

