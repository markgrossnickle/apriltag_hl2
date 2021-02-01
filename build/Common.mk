#
# File listings
#

TARGET = AprilTag

SRCS = ../common/g2d.c \
       ../common/homography.c \
       ../common/image_u8.c \
       ../common/image_u8x3.c \
       ../common/matd.c \
       ../common/pnm.c \
       ../common/string_util.c \
       ../common/svd22.c \
       ../common/time_util.c \
       ../common/unionfind.c \
       ../common/workerpool.c \
       ../common/zarray.c \
       ../common/zhash.c \
       ../common/zmaxheap.c \
       ../apriltag.c \
       ../apriltag_pose.c \
       ../apriltag_quad_thresh.c \
       ../tagStandard41h12.c

#
# Intermediate/output files
#

OBJS = $(SRCS:.c=.o)

ifeq ($(OUTPUT_TYPE), so)
  OUTPUT = lib$(TARGET).so
else ifeq ($(OUTPUT_TYPE), a)
  OUTPUT = lib$(TARGET).a
else
  OUTPUT = $(TARGET).$(OUTPUT_TYPE)
endif

#
# Compiler/linker options
#

CCFLAGS += -O2 -Wall -I..
LDFLAGS += -shared

ifeq ($(OUTPUT_TYPE), dll)
else ifeq ($(OUTPUT_TYPE), a)
else
  CCFLAGS += -fPIC
  LDFLAGS += -rdynamic -fPIC
endif

ifndef PTHREAD
  PTHREAD = -lpthread
endif

#
# Toolchain
#

ifndef AR
  AR = ar
endif

ifndef CC
  CC = gcc
endif

ifndef STRIP
  STRIP = strip
endif

#
# Building rules
#

all: $(OUTPUT)

clean:
	rm -f $(OUTPUT) $(OBJS)

$(TARGET).dll: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^ $(PTHREAD)
	$(STRIP) $@

$(TARGET).bundle: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^ $(PTHREAD)

lib$(TARGET).so: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^ $(PTHREAD)
	$(STRIP) $@

lib$(TARGET).a : $(OBJS)
	$(AR) -crv $@ $^

.c.o:
	$(CC) $(CCFLAGS) -c -o $@ $<
