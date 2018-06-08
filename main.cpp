#include <gumbo.h>
#include <Node.hpp>
#include <Document.hpp>
#include <string>
#include <iostream>
#include <sstream>
#include <gumbo.h>
#include <fstream>


std::string string_refToCString(const boost::string_ref &n) {
	std::string s(n.begin(), n.end());
	return s;
}

const char *allocAndCopyString(const std::string &s) {
	char *out = (char*)::malloc(s.size() + 1);
	::memset(out, '\0', s.size() + 1);
	::memcpy(out, s.c_str(), s.size());
	return out;
}

using namespace gq;

extern "C" {
	typedef struct {
		Document *doc;
	} WrappedDocument;

	typedef struct {
		Selection *sel;
	} WrappedSelection;

	typedef struct {
		const Node *node;
	} WrappedNode;


	const char* GetVersion() {
		return "0.1-5";
	}

	// ============================================================================================== Document

	WrappedDocument *CreateDocument() {
		WrappedDocument *d = new WrappedDocument;
		d->doc = NULL;
		return d;
	}

	void RemoveDocument(WrappedDocument *document) {
		//std::cout << "void RemoveDocument" << std::endl;
		if(document->doc != NULL) {
			delete document->doc;
		}
		delete document;
	}

	bool DocumentParse(WrappedDocument *document, const char *html) {
		try {
			if(document->doc != NULL) {
				delete document->doc;
				document->doc = NULL;
			}

			GumboOutput* output = gumbo_parse(html);
			auto tmp = Document::Create(output);
			document->doc = tmp.release();
			//document->doc->Parse(html);

		} catch(std::runtime_error& e) {
			std::cout << e.what() << std::endl;
			return false;
		}
		return true;
	}


	WrappedNode *DocumentGetParent(WrappedDocument *in_document) {
		if(in_document->doc) {
			WrappedNode *node = new WrappedNode;
			node->node = in_document->doc->GetParent();
			return node;
		}
		return NULL;
	}

	size_t DocumentGetIndexWithinParent(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetIndexWithinParent();
		}
		return 0;
	}

	size_t DocumentGetNumChildren(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetNumChildren();
		}
		return 0;
	}

	WrappedNode *DocumentGetChildAt(WrappedDocument *in_document, const size_t index) {
		if(in_document->doc) {
			WrappedNode *node = new WrappedNode;
			node->node = in_document->doc->GetChildAt(index);
			return node;
		}
		return NULL;
	}

	bool DocumentHasAttribute(WrappedDocument *document, const char *attributeName) {
		if(document->doc) {
			return document->doc->HasAttribute(boost::string_ref(attributeName));
		}
		return false;
	}

	bool DocumentIsEmpty(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->IsEmpty();
		}
		return false;
	}

	const char* DocumentGetAttributeValue(WrappedDocument *document, const char* attributeName) {
		if(document->doc) {
			return allocAndCopyString(string_refToCString(document->doc->GetAttributeValue(attributeName)));
		}
		return allocAndCopyString("");
	}

	const char* DocumentGetText(WrappedDocument *document) {
		if(document->doc) {
			return allocAndCopyString(document->doc->GetText().c_str());
		}
		return allocAndCopyString("");
	}

	const char* DocumentGetOwnText(WrappedDocument *document) {
		if(document->doc) {
			return allocAndCopyString(document->doc->GetOwnText().c_str());
		}
		return allocAndCopyString("");
	}

	const size_t DocumentGetStartPosition(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetStartPosition();
		}
		return 0;
	}

	const size_t DocumentGetEndPosition(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetEndPosition();
		}
		return 0;
	}

	const size_t DocumentGetStartOuterPosition(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetStartOuterPosition();
		}
		return 0;
	}

	const size_t DocumentGetEndOuterPosition(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetEndOuterPosition();
		}
		return 0;
	}

	const char* DocumentGetTagName(WrappedDocument *document) {
		if(document->doc) {
			return allocAndCopyString(string_refToCString(document->doc->GetTagName()));
		}
		return allocAndCopyString("");
	}

	const GumboTag DocumentGetTag(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetTag();
		}
		return GUMBO_TAG_UNKNOWN;
	}

	WrappedSelection *DocumentFind(WrappedDocument *document, const char *selectorString) {
		if(document->doc) {
			try {
				WrappedSelection *s = new WrappedSelection;
				const Selection selection = document->doc->Find(selectorString);

				std::vector<const Node*> nodes;
				for(size_t i=0;i<selection.GetNodeCount();i++) {
					nodes.push_back(selection.GetNodeAt(i));
				}

				s->sel = new Selection(nodes);

				return s;
			} catch(std::runtime_error& e) {
				std::cout << e.what() << std::endl;
				return NULL;
			}
		}
		return NULL;
	}

	void DocumentEach(WrappedDocument *document, const char *selectorString, void (*func)(WrappedNode *node)) {
		if(document->doc) {
			std::function<void(const Node* node)> lambda = [=](const Node* node) {
				WrappedNode *n = new WrappedNode;
				n->node = node;
				func(n);
			};
			return document->doc->Each(selectorString, lambda);
		}
		return;
	}

	const char* DocumentGetUniqueId(WrappedDocument *document) {
		if(document->doc) {
			return allocAndCopyString(string_refToCString(document->doc->GetUniqueId()));
		}
		return allocAndCopyString("");
	}

	const char* DocumentGetInnerHtml(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetInnerHtml().c_str();
		}
		return allocAndCopyString("");
	}

	const char* DocumentGetOuterHtml(WrappedDocument *document) {
		if(document->doc) {
			return document->doc->GetOuterHtml().c_str();
		}
		return allocAndCopyString("");
	}

	// ============================================================================================== Node

	WrappedNode *NodeGetParent(WrappedNode *in_node) {
		WrappedNode *node = new WrappedNode;
		node->node = in_node->node->GetParent();
		return node;
	}

	size_t NodeGetIndexWithinParent(WrappedNode *node) {
		return node->node->GetIndexWithinParent();
	}

	size_t NodeGetNumChildren(WrappedNode *node) {
		return node->node->GetNumChildren();
	}

	WrappedNode *NodeGetChildAt(WrappedNode *in_node, const size_t index) {
		WrappedNode *node = new WrappedNode;
		node->node = in_node->node->GetChildAt(index);
		return node;
	}

	bool NodeHasAttribute(WrappedNode *node, const char *attributeName) {
		return node->node->HasAttribute(boost::string_ref(attributeName));
	}

	bool NodeIsEmpty(WrappedNode *node) {
		return node->node->IsEmpty();
	}

	const char* NodeGetAttributeValue(WrappedNode *node, const char* attributeName) {
		return allocAndCopyString(string_refToCString(node->node->GetAttributeValue(attributeName)));
	}

	const char* NodeGetText(WrappedNode *node) {
		return allocAndCopyString(node->node->GetText().c_str());
	}

	const char* NodeGetOwnText(WrappedNode *node) {
		return allocAndCopyString(node->node->GetOwnText().c_str());
	}

	const size_t NodeGetStartPosition(WrappedNode *node) {
		return node->node->GetStartPosition();
	}

	const size_t NodeGetEndPosition(WrappedNode *node) {
		return node->node->GetEndPosition();
	}

	const size_t NodeGetStartOuterPosition(WrappedNode *node) {
		return node->node->GetStartOuterPosition();
	}

	const size_t NodeGetEndOuterPosition(WrappedNode *node) {
		return node->node->GetEndOuterPosition();
	}

	const char* NodeGetTagName(WrappedNode *node) {
		return allocAndCopyString(string_refToCString(node->node->GetTagName()));
	}

	const GumboTag NodeGetTag(WrappedNode *node) {
		return node->node->GetTag();
	}

	WrappedSelection *NodeFind(WrappedNode *node, const char *selectorString) {
		try {
			WrappedSelection *s = new WrappedSelection;
			const Selection selection = node->node->Find(selectorString);

			std::vector<const Node*> nodes;
			for(size_t i=0;i<selection.GetNodeCount();i++) {
				nodes.push_back(selection.GetNodeAt(i));
			}

			s->sel = new Selection(nodes);

			return s;
		} catch(std::runtime_error& e) {
			std::cout << e.what() << std::endl;
			return NULL;
		}
	}

	void NodeEach(WrappedNode *node, const char *selectorString, void (*func)(WrappedNode *node)) {
		std::function<void(const Node* node)> lambda = [=](const Node* node) {
			WrappedNode *n = new WrappedNode;
			n->node = node;
			func(n);
		};
		return node->node->Each(selectorString, lambda);
	}

	const char* NodeGetUniqueId(WrappedNode *node) {
		return allocAndCopyString(string_refToCString(node->node->GetUniqueId()));
	}

	const char* NodeGetInnerHtml(WrappedNode *node) {
		return allocAndCopyString(node->node->GetInnerHtml().c_str());
	}

	const char* NodeGetOuterHtml(WrappedNode *node) {
		return allocAndCopyString(node->node->GetOuterHtml().c_str());
	}

	void RemoveNode(WrappedNode *node) {
		delete node;
	}

	// ============================================================================================== Selection

	WrappedNode *SelectionGetNodeAt(WrappedSelection *selection, const size_t index) {
		WrappedNode *node = new WrappedNode;
		node->node = selection->sel->GetNodeAt(index);
		return node;
	}

	void RemoveSelection(WrappedSelection *selection) {
		delete selection;
	}

	size_t SelectionNodeCount(WrappedSelection *selection) {
		return selection->sel->GetNodeCount();
	}
}


/*
int main(int argc, char *argv[]) {
	if (argc != 2) {
		std::cout << "Usage: find_links <html filename>.\n";
		exit(EXIT_FAILURE);
	}
	const char* filename = argv[1];

	std::ifstream in(filename, std::ios::in | std::ios::binary);
	if (!in) {
		std::cout << "File " << filename << " not found!\n";
		exit(EXIT_FAILURE);
	}

	std::string contents;
	in.seekg(0, std::ios::end);
	contents.resize(in.tellg());
	in.seekg(0, std::ios::beg);
	in.read(&contents[0], contents.size());
	in.close();

	//std::string someHtmlString = "<h1>Hello, World!</h1>";
	std::string someSelectorString = "a";

	GumboOutput* output = gumbo_parse(contents.c_str());
	auto testDocument = gq::Document::Create(output);

	try {
		//testDocument->Parse(contents.c_str());

	    auto results = testDocument->Find(someSelectorString);
	    auto numResults = results.GetNodeCount();
	    for(int i=0;i<numResults;i++) {
	    	auto n = results.GetNodeAt(i)->GetAttributeValue("href");
	    	std::cout << "AA " << n << std::endl;
	    }
	    std::cout << numResults << std::endl;
	} catch(std::runtime_error& e) {
		std::cout << "exception! => " << e.what() << std::endl;
	}

	return 0;
}

*/