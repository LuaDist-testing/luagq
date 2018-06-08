FILES := main.cpp \
gq/AttributeSelector.cpp \
gq/BinarySelector.cpp \
gq/Document.cpp \
gq/Node.cpp \
gq/NodeMutationCollection.cpp \
gq/Parser.cpp  \
gq/Selection.cpp  \
gq/Selector.cpp  \
gq/Serializer.cpp  \
gq/SpecialTraits.cpp  \
gq/TextSelector.cpp \
gq/TreeMap.cpp \
gq/UnarySelector.cpp \
gq/Util.cpp \
gumbo/attribute.c \
gumbo/char_ref.c \
gumbo/error.c \
gumbo/parser.c \
gumbo/string_buffer.c \
gumbo/string_piece.c \
gumbo/tag.c \
gumbo/tokenizer.c \
gumbo/utf8.c \
gumbo/util.c \
gumbo/vector.c


OBJECTS := main.o \
gq/AttributeSelector.o \
gq/BinarySelector.o \
gq/Document.o \
gq/Node.o \
gq/NodeMutationCollection.o \
gq/Parser.o  \
gq/Selection.o  \
gq/Selector.o  \
gq/Serializer.o  \
gq/SpecialTraits.o  \
gq/TextSelector.o \
gq/TreeMap.o \
gq/UnarySelector.o \
gq/Util.o \
gumbo/attribute.o \
gumbo/char_ref.o \
gumbo/error.o \
gumbo/parser.o \
gumbo/string_buffer.o \
gumbo/string_piece.o \
gumbo/tag.o \
gumbo/tokenizer.o \
gumbo/utf8.o \
gumbo/util.o \
gumbo/vector.o

$CC = gcc
$CXX= g++

UNAME = $(shell uname -s)

ifeq ($(UNAME),Darwin)
	# clang
	CPPFLAG = -std=c++11
else
	# gnu
	GCC_VERSION=$(shell gcc -dumpversion | (IFS=. read -r major minor micro; printf "%2d%02d%02d" $${major:-0} $${minor:-0} $${micro:-0}))
	GCC_GE40700=$(shell if [ $(GCC_VERSION) -ge 40700 ]; then echo yes; fi)

	ifeq ($(GCC_GE40700),yes)
		CPPFLAG = -std=c++11
	else
		CPPFLAG = -std=c++0x
	endif
endif

libluagq: $(OBJECTS)
	@echo "==== Linking ... ===="
	$(CXX) -o $@.so -shared $(OBJECTS)

#main: $(OBJECTS)
#	@echo "==== Linking ... ===="
#	$(CXX) -o $@ $(OBJECTS)

.cpp.o:
	@echo "==== C++ Building ... ===="
	$(CXX) -fPIC -c $< -o $@ -I./gq -I./gumbo $(CPPFLAG)

.c.o:
	@echo "==== C Building ... ===="
	$(CC) -fPIC -c $< -o $@ -I./gq -I./gumbo -std=c99

.PHONY: clean
clean:
	rm -f $(OBJECTS)
	rm -f libluagq.so

install:
	cp libluagq.so /usr/local/lib/libluagq.so

uninstall:
	rm -f /usr/local/lib/libluagq.so
