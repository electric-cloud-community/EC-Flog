# Makefile

SRCTOP=..
include $(SRCTOP)/build/vars.mak

build: package
PLUGIN_PATCH_LEVEL=2.0.3
unittest:
systemtest: test-setup test-run
flogtest:
	$(MAKE) NTESTFILES="systemtest/cppncss.ntest" RUNFLOGTESTS=1 test-setup test-run

NTESTFILES ?= systemtest

test-setup:
	$(EC_PERL) ../EC-Flog/systemtest/setup.pl $(TEST_SERVER) $(PLUGINS_ARTIFACTS)

test-run: systemtest-run

include $(SRCTOP)/build/rules.mak
