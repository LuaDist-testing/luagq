# luagq


[GQ](https://github.com/TechnikEmpire/GQ)をSharedLibrary化したモジュールをLuajit FFIで呼び出すモジュールです。

libluagq.so(gumbo -> GQ -> C wrapper) -> FFI -> Luajit

# 依存

[Penlight](https://github.com/stevedonovan/Penlight)

Luajit >= 2.1

# インストール
`$ luarocks install luagq`

# 使い方
```lua
local Document = require "luagq.document"
local file = require "pl.file"

local html = file.read("./sample.html")

local document = Document()
document:parse(html)

local selection = document:find("title")
local node = selection:getNodeAt(0)
local text = node:getText()

print("text => ", text)

node:close()
selection:close()
document:close()

```

# API

## class Document

* HTMLをパースし内部に保持する。
* CSSセレクタ文字でクエリ結果をSelectionとして返す。
* オブジェクトの使用後は必ずcloseを呼び出すこと。
* Nodeクラスの持っている関数インターフェースと下位互換を持っている。


### close

オブジェクトを破棄する。

### parse

* 引数 : html

HTMLをパースする。



## class Node

* HTMLタグの属性、下位のNodeを保持する。
* オブジェクトの使用後は必ずcloseを呼び出すこと。

### getParent

親となるNodeを返す。

### getIndexWithinParent

### getNumChildren

子Nodeの数を返す。

### getChildAt

* 引数 : index

index番目の子Nodeを返す。

### nodeHasAttribute

* 引数 : attributeName

指定属性が存在するかどうかを返す。

### nodeIsEmpty

Nodeが空かどうかを返す。

### getAttributeValue

* 引数 : attributeName

指定属性の値を返す。

### getText

自Nodeを含め全てのNodeをテキスト化し返す。

### getOwnText

子Nodeのテキスト化し返す。

### getStartPosition

### getEndPosition

### getStartOuterPosition

### getEndOuterPosition

### getTagName

HTMLタグ名を返す。

### getTag

GumboTag型でHTMLタグを返す。

### find

* 引数 : selectorString

下位Node内をCSSセレクタでクエリを行い、マッチ結果をSelectionとして返す。

### each

* 引数 : selectorString
* 引数 : func

Selectionを介すことなくマッチ結果のNodeを取得する。

```lua
document:each("body > a#link", function(node)
	local text = node:getText()
	print(text)
	node:close()
end)
```

### getUniqueId

### getInnerHtml

Node内のHTMLをテキスト化し返す。

### getOuterHtml

Node外のHTMLをテキスト化し返す。

## class Selection

* CSSセレクタのマッチ結果(Node)を保持する。
* オブジェクトの使用後は必ずcloseを呼び出すこと。


### close

オブジェクトを破棄する。

### getNodeAt

* 引数 : index

保持しているNodeを返す。

### nodeCount

保持しているNodeの数を返す。
