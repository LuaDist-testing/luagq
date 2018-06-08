local ffi = require "ffi"
local class = require "pl.class"
local bridge = require "luagq.bridge"
local node = require "luagq.node"
local version = require "luagq.version"

class.selection {

	_version = version,

	_wrappped_selection = nil,

	--- constructor
	--
	_init = function(self, wrapped_selection)
		assert(wrapped_selection)
		self._wrappped_selection = wrapped_selection
		ffi.gc(self._wrappped_selection, function(wrapped_selection)
			--print("selection gc")
			bridge.RemoveSelection(wrapped_selection)
		end)
	end;

	---
	--
	__tostring = function(self)
		return "libluagq selection " .. self._version
	end;

	---
	--
	close = function(self)
		self._wrappped_selection = nil
	end;

	--- choise query node
	-- @table NodeClass
	getNodeAt = function(self, index)
		assert(self._wrappped_selection)
		return node(bridge.SelectionGetNodeAt(self._wrappped_selection, index))
	end;

	--- count query resultset
	-- @number result count
	nodeCount = function(self)
		assert(self._wrappped_selection)
		return tonumber(bridge.SelectionNodeCount(self._wrappped_selection))
	end;
}

return selection