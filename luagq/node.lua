local ffi = require "ffi"
local class = require "pl.class"
local bridge = require "luagq.bridge"
local version = require "luagq.version"

class.node {

	_version = version,

	_wrappped_node = nil,

	--- constructor
	--
	_init = function(self, wrapped_selection)
		assert(wrapped_selection)
		self._wrappped_node = wrapped_selection
		ffi.gc(self._wrappped_node, function(wrapped_node)
			--print("node gc")
			bridge.RemoveNode(wrapped_node)
		end)
	end;

	---
	--
	__tostring = function(self)
		return "libluagq node " .. self._version
	end;

	---
	--
	close = function(self)
		self._wrappped_node = nil
	end;

	--- gets the parent of this node
	-- @return table NodeClass
	getParent = function(self)
		assert(self._wrappped_node)
		return node(bridge.NodeGetParent(self._wrappped_node))
	end;

	---
	-- @return number
	getIndexWithinParent = function(self)
		assert(self._wrappped_node)
		return tonumber(bridge.NodeGetIndexWithinParent(self._wrappped_node))
	end;

	---
	-- @return number
	getNumChildren = function(self)
		assert(self._wrappped_node)
		return tonumber(bridge.NodeGetNumChildren(self._wrappped_node))
	end;

	---
	-- @return table NodeClass
	getChildAt = function(self, index)
		assert(self._wrappped_node)
		return node(bridge.NodeGetChildAt(self._wrappped_node, index))
	end;

	---
	-- @return boolean
	nodeHasAttribute = function(self, attributeName)
		assert(self._wrappped_node)
		return bridge.NodeHasAttribute(self._wrappped_node, attributeName)
	end;

	---
	-- @return boolean
	nodeIsEmpty = function(self)
		assert(self._wrappped_node)
		return bridge.NodeIsEmpty(self._wrappped_node)
	end;

	---
	-- @return string
	getAttributeValue = function(self, attributeName)
		assert(self._wrappped_node)
		local ret = bridge.NodeGetAttributeValue(self._wrappped_node, attributeName)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getText = function(self)
		assert(self._wrappped_node)
		local ret = bridge.NodeGetText(self._wrappped_node)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getOwnText = function(self)
		assert(self._wrappped_node)
		local ret = bridge.NodeGetOwnText(self._wrappped_node)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return number
	getStartPosition = function(self)
		assert(self._wrappped_node)
		return tonumber(bridge.NodeGetStartPosition(self._wrappped_node))
	end;

	---
	-- @return number
	getEndPosition = function(self)
		assert(self._wrappped_node)
		return tonumber(bridge.NodeGetEndPosition(self._wrappped_node))
	end;

	---
	-- @return number
	getStartOuterPosition = function(self)
		assert(self._wrappped_node)
		return tonumber(bridge.NodeGetStartOuterPosition(self._wrappped_node))
	end;

	---
	-- @return number
	getEndOuterPosition = function(self)
		assert(self._wrappped_node)
		return tonumber(bridge.NodeGetEndOuterPosition(self._wrappped_node))
	end;

	---
	-- @return string
	getTagName = function(self)
		assert(self._wrappped_node)
		local ret = bridge.NodeGetTagName(self._wrappped_node)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return number
	getTag = function(self)
		assert(self._wrappped_node)
		return tonumber(bridge.NodeGetTag(self._wrappped_node))
	end;

	---
	-- @return table SelectionClass
	find = function(self, selectorString)
		assert(self._wrappped_node)
		return selection(bridge.NodeFind(self._wrappped_node, selectorString))
	end;

	---
	--
	each = function(self, selectorString, func)
		assert(self._wrappped_node)
		local cb = ffi.cast("NodeEachCallback", function(wrapped_node)
			func(node(wrapped_node))
		end)
		bridge.NodeEach(self._wrappped_node, selectorString, cb)
		cb:free()
	end;

	---
	-- @return string
	getUniqueId = function(self)
		assert(self._wrappped_node)
		local ret = bridge.NodeGetUniqueId(self._wrappped_node)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getInnerHtml = function(self)
		assert(self._wrappped_node)
		local ret = bridge.NodeGetInnerHtml(self._wrappped_node)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;

	---
	-- @return string
	getOuterHtml = function(self)
		assert(self._wrappped_node)
		local ret = bridge.NodeGetOuterHtml(self._wrappped_node)
		ffi.gc(ffi.cast("void*", ret), bridge.free)
		return ffi.string(ret)
	end;
}

return node