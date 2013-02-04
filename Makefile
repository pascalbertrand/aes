.PHONY=clean


#Tools
CP=cp


#Compilation options
ASFLAGS+=-Xassembler -Iinclude
CFLAGS+=-Iinclude -std=c99


#Directories
SRC=src
BUILD=build
BIN=$(BUILD)/bin
OBJ=$(BUILD)/obj
TESTSRC=test/src
TESTDIR=$(BUILD)/test
TESTBIN=$(TESTDIR)/bin
TESTOBJ=$(TESTDIR)/obj
DIRS=$(BIN) $(OBJ) $(TESTBIN) $(TESTOBJ)


#Source files
COBJECTS=$(wildcard $(SRC)/*.c)
SOBJECTS=$(wildcard $(SRC)/*.s)
SCRIPTS=$(wildcard $(TESTSRC)/*.py)


#Targets files
TARGET=$(BIN)/aes
OBJECTS=$(COBJECTS:$(SRC)/%.c=$(OBJ)/%.o) $(SOBJECTS:$(SRC)/%.s=$(OBJ)/%.o)


#Tests targets files
TESTSTARGETS=$(COBJECTS:$(SRC)/%.c=$(TESTBIN)/%) $(SOBJECTS:$(SRC)/%.s=$(TESTBIN)/%.so) $(TESTBIN)/key_helper.so
TESTS=$(SCRIPTS:$(TESTSRC)/%.py=$(BUILD)/%.py)


#Top level rules
all: $(TARGET)

$(DIRS):
	mkdir -p $@

$(TARGET): $(BIN) $(OBJ) $(OBJECTS)
	$(CC) -o $@ $(OBJECTS)

tests: $(TESTBIN) $(TESTOBJ) $(TESTSTARGETS) $(TESTS)
	python -m unittest -v $(BUILD)


#Targets rules
$(BUILD)/%.py: $(TESTSRC)/%.py
	$(CP) $< $@

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ)/%.o: $(SRC)/%.s
	$(CC) $(ASFLAGS) -c -o $@ $<


#Tests rules
$(TESTBIN)/main: src/main.c test/src/aes.c
	$(CC) $(CFLAGS) -o $@ $^

$(TESTBIN)/%.so: $(TESTOBJ)/%.o
	$(CC) -shared -o $@ $<

$(TESTOBJ)/%.o: $(SRC)/%.s
#	$(CC) $(ASFLAGS) -fPIC -c -o $@ $<
	$(CC) $(ASFLAGS) -c -o $@ $<

$(TESTOBJ)/%.o: $(TESTSRC)/%.s
#	$(CC) $(ASFLAGS) -fPIC -c -o $@ $<
	$(CC) $(ASFLAGS) -c -o $@ $<


#Clean up rules
clean:
	rm -rf $(BUILD)

