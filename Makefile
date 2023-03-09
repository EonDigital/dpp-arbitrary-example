DIR_BUILD:=$(or ${DIR_BUILD},build)
DIR_OBJS:=$(DIR_BUILD)/objs
DIR_SRC_ROOT:=$(or ${DIR_SRC_ROOT},src)

DIR_DEP_DPP:=$(or ${DIR_DEP_DPP},../DPP)

DIR_SRC:=$(DIR_SRC_ROOT) $(addprefix $(DIR_SRC_ROOT)/,)

SRCS:=$(sort $(foreach d,$(DIR_SRC),$(wildcard $(d)/*.cpp $(d)/*.cc $(d)/*.c)))
OBJS:=$(patsubst $(DIR_SRC_ROOT)/%,$(DIR_OBJS)/%.o,$(SRCS))
DEPS:=$(patsubst $(DIR_SRC_ROOT)/%,$(DIR_OBJS)/%.d,$(SRCS))

DIRS:=$(sort $(DIR_BUILD) $(DIR_SRC_ROOT) $(dir $(OBJS)))

EQ = =

PRINT=$(info $(1) $(EQ) $(value $(1)))

#$(call PRINT,SRCS)
#$(call PRINT,OBJS)

.PHONY: all run_example clean

CPPFLAGS:=-MMD -MP -Os
CXXFLAGS:=-std=c++17 -I$(DIR_DEP_DPP)/include
LDFLAGS:=-L$(DIR_DEP_DPP)/build/library
LDLIBS:=-ldpp -lstdc++

all: $(DIR_BUILD)/example.out

run_example :
	LD_LIBRARY_PATH=$(DIR_DEP_DPP)/build/library $(DIR_BUILD)/example.out

clean :
	rm -r $(DIR_BUILD)

$(OBJS) : $(DIR_OBJS)/%.o : $(DIR_SRC_ROOT)/%

$(DIR_BUILD)/example.out : $(OBJS)

$(filter %.c.o,$(OBJS)) :
	echo "Building  $@"
	-mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $(@) $(<)
	echo "Completed $@"

$(filter %.cc.o %.cpp.o,$(OBJS)) :
	echo "Building  $@"
	-mkdir -p $(@D)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $(@) $(<)
	echo "Completed $@"

$(DIR_BUILD)/example.out :
	echo "Linking   $@"
	-mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(<) $(LOADLIBES) $(LDLIBS) -o $(@)
	echo "Completed $@"

-include $(DEPS)
