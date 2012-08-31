GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=work

TEST_BENCH = test_bench \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

test_bench: mt19937ar.o test_bench.o mt32_gen.o mt32_1w1r_ram.o sdpram.o sdpram_model.o 
	 $(GHDL) -e $(GHDLFLAGS) $@
	-$(GHDL) -r $(GHDLRUNFLAGS) $@

test_bench.o   :  ../../src/test/vhdl/test_bench.vhd Dummy_Plug
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

mt32_gen.o     :  ../../src/main/vhdl/mt32_gen.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

mt32_1w1r_ram.o:  ../../src/main/vhdl/mt32_1w1r_ram.vhd PipeWork
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

Dummy_Plug     : mt19937ar.o

mt19937ar.o    :  ../../Dummy_Plug/src/main/vhdl/core/mt19937ar.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=Dummy_Plug $<

PipeWork       : sdpram.o sdpram_model.o components.o

components.o   :  ../../PipeWork/src/main/vhdl/components/components.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PipeWork $<

sdpram.o       :  ../../PipeWork/src/main/vhdl/components/sdpram.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PipeWork $<

sdpram_model.o :  ../../PipeWork/src/main/vhdl/components/sdpram_model.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PipeWork $<
