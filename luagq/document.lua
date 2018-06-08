local ffi = require "ffi"
local class = require "pl.class"
local bridge = require "luagq.bridge"
local selection = require "luagq.selection"
local version = require "luagq.version"

class.document {

	_version = version,

	_wrappped_document = nil,

	--- constructor
	--
	_init = function(self)
		self._wrappped_document = bridge.CreateDocument()
		ffi.gc(self._wrappped_document, function(wrappped_document)
			--print("document gc")
			bridge.RemoveDocument(wrappped_document)
		end)
	end;

	---
	--
	__tostring = function(self)
		return "libluagq document " .. self._version
	end;

	---
	--
	bridgeVersion = function(self)
		return ffi.string(bridge.GetVersion())
	end;

	---
	--
	close = function(self)
		self._wrappped_document = nil
	end;

	--- parse HTML
	-- @string html
	-- @return boolean success or failure
	parse = function(self, html)
		assert(self._wrappped_document)
		assert(type(html) == "string")
		return bridge.DocumentParse(self._wrappped_document, html)
	end;

	--- gets the parent of this node
	-- @return table NodeClass
	getParent = function(self)
		assert(self._wrappped_document)
		return node(bridge.DocumentGetParent(self._wrappped_document))
	end;

	---
	-- @return number
	getIndexWithinParent = function(self)
		assert(self._wrappped_document)
		return tonumber(bridge.DocumentGetIndexWithinParent(self._wrappped_document))
	end;

	---
	-- @return number
	getNumChildren = function(self)
		assert(self._wrappped_document)
		return tonumber(bridge.DocumentGetNumChildren(self._wrappped_document))
	end;

	---
	-- @return table NodeClass
	getChildAt = function(self, index)
		assert(self._wrappped_document)
		return node(bridge.DocumentGetChildAt(self._wrappped_document, index))
	end;

	---
	-- @return boolean
	nodeHasAttribute = function(self, attributeName)
		assert(self._wrappped_document)
		return bridge.DocumentHasAttribute(self._wrappped_document, attributeName)
	end;

	---
	-- @return boolean
	nodeIsEmpty = function(self)
		assert(self._wrappped_document)
		return bridge.DocumentIsEmpty(self._wrappped_document)
	end;

	---
	-- @return string
	getAttributeValue = function(self, attributeName)
		assert(self._wrappped_document)
		local ret = bridge.DocumentGetAttributeValue(self._wrappped_document, attributeName)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getText = function(self)
		assert(self._wrappped_document)
		local ret = bridge.DocumentGetText(self._wrappped_document)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getOwnText = function(self)
		assert(self._wrappped_document)
		local ret = bridge.DocumentGetOwnText(self._wrappped_document)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return number
	getStartPosition = function(self)
		assert(self._wrappped_document)
		return tonumber(bridge.DocumentGetStartPosition(self._wrappped_document))
	end;

	---
	-- @return number
	getEndPosition = function(self)
		assert(self._wrappped_document)
		return tonumber(bridge.DocumentGetEndPosition(self._wrappped_document))
	end;

	---
	-- @return number
	getStartOuterPosition = function(self)
		assert(self._wrappped_document)
		return tonumber(bridge.DocumentGetStartOuterPosition(self._wrappped_document))
	end;

	---
	-- @return number
	getEndOuterPosition = function(self)
		assert(self._wrappped_document)
		return tonumber(bridge.DocumentGetEndOuterPosition(self._wrappped_document))
	end;

	---
	-- @return string
	getTagName = function(self)
		assert(self._wrappped_document)
		local ret = bridge.DocumentGetTagName(self._wrappped_document)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return number
	getTag = function(self)
		assert(self._wrappped_document)
		return tonumber(bridge.DocumentGetTag(self._wrappped_document))
	end;

	---
	-- @return table SelectionClass
	find = function(self, selectorString)
		assert(self._wrappped_document)
		return selection(bridge.DocumentFind(self._wrappped_document, selectorString))
	end;

	---
	--
	each = function(self, selectorString, func)
		assert(self._wrappped_document)
		local cb = ffi.cast("NodeEachCallback", function(wrapped_node)
			func(node(wrapped_node))
		end)
		bridge.DocumentEach(self._wrappped_document, selectorString, cb)
		cb:free()
	end;

	---
	-- @return string
	getUniqueId = function(self)
		assert(self._wrappped_document)
		local ret = bridge.DocumentGetUniqueId(self._wrappped_document)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getInnerHtml = function(self)
		assert(self._wrappped_document)
		local ret = bridge.DocumentGetInnerHtml(self._wrappped_document)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getOuterHtml = function(self)
		assert(self._wrappped_document)
		local ret = bridge.DocumentGetOuterHtml(self._wrappped_document)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

}

return document