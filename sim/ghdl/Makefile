GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=work

TEST_BENCH = test_bench \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

test_bench: mt19937ar.o test_bench.o mt32_rand_gen.o mt32_rand_ram.o mt32_rand_ram_auto.o mt32_rand_ram_xilinx_ramb.o mt32_rand_ram_xilinx_lut.o 
	 $(GHDL) -e $(GHDLFLAGS) $@
	-$(GHDL) -r $(GHDLRUNFLAGS) $@

test_bench.o    :  ../../src/test/vhdl/test_bench.vhd mt32_rand_gen.o
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

mt32_rand_gen.o :  ../../src/main/vhdl/mt32_rand_gen.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<

mt32_rand_ram.o:  ../../src/main/vhdl/mt32_rand_ram.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<

mt32_rand_ram_auto.o       :  ../../src/main/vhdl/mt32_rand_ram_auto.vhd        mt32_rand_ram.o
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<

mt32_rand_ram_xilinx_ramb.o:  ../../src/main/vhdl/mt32_rand_ram_xilinx_ramb.vhd mt32_rand_ram.o
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<

mt32_rand_ram_xilinx_lut.o :  ../../src/main/vhdl/mt32_rand_ram_xilinx_lut.vhd  mt32_rand_ram.o
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<

mt19937ar.o    :  ../../src/main/vhdl/mt19937ar.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<
