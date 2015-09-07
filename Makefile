PROJECT = lupyter

include resources/make/common.mk
include resources/make/otp.mk
include resources/make/lupyter.mk
include resources/make/debug.mk

.DEFAULT_GOAL := all
