local ffi = require "ffi"

ffi.cdef([[
	// ==============================================================================================
	typedef struct {} WrappedDocument;
	typedef struct {} WrappedSelection;
	typedef struct {} WrappedNode;
	typedef void (*NodeEachCallback)(WrappedNode *node);

	typedef enum {
		GUMBO_TAG_HTML,
		GUMBO_TAG_HEAD,
		GUMBO_TAG_TITLE,
		GUMBO_TAG_BASE,
		GUMBO_TAG_LINK,
		GUMBO_TAG_META,
		GUMBO_TAG_STYLE,
		GUMBO_TAG_SCRIPT,
		GUMBO_TAG_NOSCRIPT,
		GUMBO_TAG_TEMPLATE,
		GUMBO_TAG_BODY,
		GUMBO_TAG_ARTICLE,
		GUMBO_TAG_SECTION,
		GUMBO_TAG_NAV,
		GUMBO_TAG_ASIDE,
		GUMBO_TAG_H1,
		GUMBO_TAG_H2,
		GUMBO_TAG_H3,
		GUMBO_TAG_H4,
		GUMBO_TAG_H5,
		GUMBO_TAG_H6,
		GUMBO_TAG_HGROUP,
		GUMBO_TAG_HEADER,
		GUMBO_TAG_FOOTER,
		GUMBO_TAG_ADDRESS,
		GUMBO_TAG_P,
		GUMBO_TAG_HR,
		GUMBO_TAG_PRE,
		GUMBO_TAG_BLOCKQUOTE,
		GUMBO_TAG_OL,
		GUMBO_TAG_UL,
		GUMBO_TAG_LI,
		GUMBO_TAG_DL,
		GUMBO_TAG_DT,
		GUMBO_TAG_DD,
		GUMBO_TAG_FIGURE,
		GUMBO_TAG_FIGCAPTION,
		GUMBO_TAG_MAIN,
		GUMBO_TAG_DIV,
		GUMBO_TAG_A,
		GUMBO_TAG_EM,
		GUMBO_TAG_STRONG,
		GUMBO_TAG_SMALL,
		GUMBO_TAG_S,
		GUMBO_TAG_CITE,
		GUMBO_TAG_Q,
		GUMBO_TAG_DFN,
		GUMBO_TAG_ABBR,
		GUMBO_TAG_DATA,
		GUMBO_TAG_TIME,
		GUMBO_TAG_CODE,
		GUMBO_TAG_VAR,
		GUMBO_TAG_SAMP,
		GUMBO_TAG_KBD,
		GUMBO_TAG_SUB,
		GUMBO_TAG_SUP,
		GUMBO_TAG_I,
		GUMBO_TAG_B,
		GUMBO_TAG_U,
		GUMBO_TAG_MARK,
		GUMBO_TAG_RUBY,
		GUMBO_TAG_RT,
		GUMBO_TAG_RP,
		GUMBO_TAG_BDI,
		GUMBO_TAG_BDO,
		GUMBO_TAG_SPAN,
		GUMBO_TAG_BR,
		GUMBO_TAG_WBR,
		GUMBO_TAG_INS,
		GUMBO_TAG_DEL,
		GUMBO_TAG_IMAGE,
		GUMBO_TAG_IMG,
		GUMBO_TAG_IFRAME,
		GUMBO_TAG_EMBED,
		GUMBO_TAG_OBJECT,
		GUMBO_TAG_PARAM,
		GUMBO_TAG_VIDEO,
		GUMBO_TAG_AUDIO,
		GUMBO_TAG_SOURCE,
		GUMBO_TAG_TRACK,
		GUMBO_TAG_CANVAS,
		GUMBO_TAG_MAP,
		GUMBO_TAG_AREA,
		GUMBO_TAG_MATH,
		GUMBO_TAG_MI,
		GUMBO_TAG_MO,
		GUMBO_TAG_MN,
		GUMBO_TAG_MS,
		GUMBO_TAG_MTEXT,
		GUMBO_TAG_MGLYPH,
		GUMBO_TAG_MALIGNMARK,
		GUMBO_TAG_ANNOTATION_XML,
		GUMBO_TAG_SVG,
		GUMBO_TAG_FOREIGNOBJECT,
		GUMBO_TAG_DESC,
		GUMBO_TAG_TABLE,
		GUMBO_TAG_CAPTION,
		GUMBO_TAG_COLGROUP,
		GUMBO_TAG_COL,
		GUMBO_TAG_TBODY,
		GUMBO_TAG_THEAD,
		GUMBO_TAG_TFOOT,
		GUMBO_TAG_TR,
		GUMBO_TAG_TD,
		GUMBO_TAG_TH,
		GUMBO_TAG_FORM,
		GUMBO_TAG_FIELDSET,
		GUMBO_TAG_LEGEND,
		GUMBO_TAG_LABEL,
		GUMBO_TAG_INPUT,
		GUMBO_TAG_BUTTON,
		GUMBO_TAG_SELECT,
		GUMBO_TAG_DATALIST,
		GUMBO_TAG_OPTGROUP,
		GUMBO_TAG_OPTION,
		GUMBO_TAG_TEXTAREA,
		GUMBO_TAG_KEYGEN,
		GUMBO_TAG_OUTPUT,
		GUMBO_TAG_PROGRESS,
		GUMBO_TAG_METER,
		GUMBO_TAG_DETAILS,
		GUMBO_TAG_SUMMARY,
		GUMBO_TAG_MENU,
		GUMBO_TAG_MENUITEM,
		GUMBO_TAG_APPLET,
		GUMBO_TAG_ACRONYM,
		GUMBO_TAG_BGSOUND,
		GUMBO_TAG_DIR,
		GUMBO_TAG_FRAME,
		GUMBO_TAG_FRAMESET,
		GUMBO_TAG_NOFRAMES,
		GUMBO_TAG_ISINDEX,
		GUMBO_TAG_LISTING,
		GUMBO_TAG_XMP,
		GUMBO_TAG_NEXTID,
		GUMBO_TAG_NOEMBED,
		GUMBO_TAG_PLAINTEXT,
		GUMBO_TAG_RB,
		GUMBO_TAG_STRIKE,
		GUMBO_TAG_BASEFONT,
		GUMBO_TAG_BIG,
		GUMBO_TAG_BLINK,
		GUMBO_TAG_CENTER,
		GUMBO_TAG_FONT,
		GUMBO_TAG_MARQUEE,
		GUMBO_TAG_MULTICOL,
		GUMBO_TAG_NOBR,
		GUMBO_TAG_SPACER,
		GUMBO_TAG_TT,
		GUMBO_TAG_RTC,

		GUMBO_TAG_UNKNOWN,
		GUMBO_TAG_LAST,
	} GumboTag;

	const char* GetVersion();

	// ============================================================================================== Document
	WrappedDocument *CreateDocument();
	bool DocumentParse(WrappedDocument *document, const char *html);
	void RemoveDocument(WrappedDocument *document);


	WrappedNode *DocumentGetParent(WrappedDocument *in_document);
	size_t DocumentGetIndexWithinParent(WrappedDocument *document);
	size_t DocumentGetNumChildren(WrappedDocument *document);
	WrappedNode *DocumentGetChildAt(WrappedDocument *in_document, const size_t index);
	bool DocumentHasAttribute(WrappedDocument *document, const char *attributeName);
	bool DocumentIsEmpty(WrappedDocument *document);
	const char* DocumentGetAttributeValue(WrappedDocument *document, const char* attributeName);
	const char* DocumentGetText(WrappedDocument *document);
	const char* DocumentGetOwnText(WrappedDocument *document);
	const size_t DocumentGetStartPosition(WrappedDocument *document);
	const size_t DocumentGetEndPosition(WrappedDocument *document);
	const size_t DocumentGetStartOuterPosition(WrappedDocument *document);
	const size_t DocumentGetEndOuterPosition(WrappedDocument *document);
	const char* DocumentGetTagName(WrappedDocument *document);
	const GumboTag DocumentGetTag(WrappedDocument *document);
	WrappedSelection *DocumentFind(WrappedDocument *document, const char *selectorString);
	void DocumentEach(WrappedDocument *document, const char *selectorString, void (*func)(WrappedNode *document));
	const char* DocumentGetUniqueId(WrappedDocument *document);
	const char* DocumentGetInnerHtml(WrappedDocument *document);
	const char* DocumentGetOuterHtml(WrappedDocument *document);

	// ============================================================================================== Node
	WrappedNode *NodeGetParent(WrappedNode *in_node);
	size_t NodeGetIndexWithinParent(WrappedNode *node);
	size_t NodeGetNumChildren(WrappedNode *node);
	WrappedNode *NodeGetChildAt(WrappedNode *in_node, const size_t index);
	bool NodeHasAttribute(WrappedNode *node, const char *attributeName);
	bool NodeIsEmpty(WrappedNode *node);
	const char* NodeGetAttributeValue(WrappedNode *node, const char* attributeName);
	const char* NodeGetText(WrappedNode *node);
	const char* NodeGetOwnText(WrappedNode *node);
	const size_t NodeGetStartPosition(WrappedNode *node);
	const size_t NodeGetEndPosition(WrappedNode *node);
	const size_t NodeGetStartOuterPosition(WrappedNode *node);
	const size_t NodeGetEndOuterPosition(WrappedNode *node);
	const char* NodeGetTagName(WrappedNode *node);
	const GumboTag NodeGetTag(WrappedNode *node);
	WrappedSelection *NodeFind(WrappedNode *node, const char *selectorString);
	void NodeEach(WrappedNode *node, const char *selectorString, void (*func)(WrappedNode *node));
	const char* NodeGetUniqueId(WrappedNode *node);
	const char* NodeGetInnerHtml(WrappedNode *node);
	const char* NodeGetOuterHtml(WrappedNode *node);
	void RemoveNode(WrappedNode *node);

	// ============================================================================================== Selection

	WrappedNode *SelectionGetNodeAt(WrappedSelection *selection, const size_t index);
	void RemoveSelection(WrappedSelection *selection);
	size_t SelectionNodeCount(WrappedSelection *selection);
]])

ffi.cdef([[
	void *malloc(size_t size);
	void free(void *ptr);
]])

if pcall(ffi.load, "libluagq.so") then
	return ffi.load("libluagq.so")
else
	return ffi.load("/usr/local/lib/libluagq.so")
end
