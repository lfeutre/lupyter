PROJECT = lupyter

include resources/make/common.mk
include resources/make/otp.mk
include resources/make/lupyter.mk

.DEFAULT_GOAL := compile
