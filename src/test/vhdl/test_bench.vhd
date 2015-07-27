-----------------------------------------------------------------------------------
--!     @file    test_bench.vhd
--!     @brief   Test Bench for MT32_GEN.
--!     @version 0.1.0
--!     @date    2015/7/26
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2012-2015 Ichiro Kawazome
--      All rights reserved.
--
--      Redistribution and use in source and binary forms, with or without
--      modification, are permitted provided that the following conditions
--      are met:
--
--        1. Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--        2. Redistributions in binary form must reproduce the above copyright
--           notice, this list of conditions and the following disclaimer in
--           the documentation and/or other materials provided with the
--           distribution.
--
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
library MT32_RAND_GEN;
use     MT32_RAND_GEN.MT19937AR.SEED_VECTOR;
use     MT32_RAND_GEN.MT19937AR.PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
use     MT32_RAND_GEN.MT19937AR.NEW_PSEUDO_RANDOM_NUMBER_GENERATOR;
use     MT32_RAND_GEN.MT19937AR.GENERATE_RANDOM_STD_LOGIC_VECTOR;
use     MT32_RAND_GEN.MT19937AR.GENERATE_RANDOM_REAL2;
entity  TEST_BENCH is
end     TEST_BENCH;
architecture MODEL of TEST_BENCH is
    constant  WIDTH       : integer := 32;
    constant  LANE        : integer :=  1;
    constant  PERIOD      : time    := 10 ns;
    constant  DELAY       : time    :=  1 ns;
    constant  N           : integer := 624;
    constant  INIT_SEED   : integer := 123;
    signal    CLK         : std_logic;
    signal    RST         : std_logic;
    signal    TBL_INIT    : std_logic;
    signal    TBL_WE      : std_logic_vector(      LANE-1 downto 0);
    signal    TBL_WPTR    : std_logic_vector(          15 downto 0);
    signal    TBL_WDATA   : std_logic_vector(WIDTH*LANE-1 downto 0);
    signal    TBL_RPTR    : std_logic_vector(          15 downto 0);
    signal    TBL_RDATA   : std_logic_vector(WIDTH*LANE-1 downto 0);
    signal    RND_RUN     : std_logic;
    signal    RND_VAL     : std_logic;
    signal    RND_NUM     : std_logic_vector(WIDTH*LANE-1 downto 0);
    constant  RUN_WAIT    : integer := 1;
begin
    U: entity MT32_RAND_GEN.MT32_RAND_GEN
        generic map(
            SEED        => INIT_SEED,
            L           => LANE
        )
        port map(
            CLK         => CLK,
            RST         => RST,
            TBL_INIT    => TBL_INIT,
            TBL_WE      => TBL_WE,
            TBL_WPTR    => TBL_WPTR,
            TBL_WDATA   => TBL_WDATA,
            TBL_RPTR    => TBL_RPTR,
            TBL_RDATA   => TBL_RDATA,
            RND_RUN     => RND_RUN,
            RND_VAL     => RND_VAL,
            RND_NUM     => RND_NUM
        );
    
    process begin
        CLK <= '1'; wait for PERIOD/2;
        CLK <= '0'; wait for PERIOD/2;
    end process;

    process
        ---------------------------------------------------------------------------
        -- unsigned to decimal string.
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:unsigned;len:integer;space:character) return STRING is
            variable str   : STRING(len downto 1);
            variable value : unsigned(arg'length-1 downto 0);
        begin
            value  := arg;
            for i in str'right to str'left loop
                if (value > 0) then
                    case (to_integer(value mod 10)) is
                        when 0      => str(i) := '0';
                        when 1      => str(i) := '1';
                        when 2      => str(i) := '2';
                        when 3      => str(i) := '3';
                        when 4      => str(i) := '4';
                        when 5      => str(i) := '5';
                        when 6      => str(i) := '6';
                        when 7      => str(i) := '7';
                        when 8      => str(i) := '8';
                        when 9      => str(i) := '9';
                        when others => str(i) := 'X';
                    end case;
                else
                    if (i = str'right) then
                        str(i) := '0';
                    else
                        str(i) := space;
                    end if;
                end if;
                value := value / 10;
            end loop;
            return str;
        end function;
        ---------------------------------------------------------------------------
        -- unsigned to decimal string
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:unsigned;len:integer) return STRING is
        begin
            return  TO_DEC_STRING(arg,len,' ');
        end function;
        ---------------------------------------------------------------------------
        -- Seed Numbers for Pseudo Random Number Generator.
        ---------------------------------------------------------------------------
        variable seed      : SEED_VECTOR(0 to 3) := (0 => X"00000123",
                                                     1 => X"00000234",
                                                     2 => X"00000345",
                                                     3 => X"00000456");
        ---------------------------------------------------------------------------
        -- Pseudo Random Number Generator Instance.
        ---------------------------------------------------------------------------
        variable prng_1    : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE := NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(INIT_SEED);
        variable prng_2    : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE := NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(seed);
        ---------------------------------------------------------------------------
        -- Random number 
        ---------------------------------------------------------------------------
        variable vec       : std_logic_vector(31 downto 0);
        ---------------------------------------------------------------------------
        -- for display
        ---------------------------------------------------------------------------
        constant TAG       : STRING(1 to 1) := " ";
        constant SPACE     : STRING(1 to 1) := " ";
        variable text_line : LINE;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        procedure WAIT_CLK(CNT:integer) is
        begin
            for i in 1 to CNT loop 
                wait until (CLK'event and CLK = '1'); 
            end loop;
            wait for DELAY;
        end WAIT_CLK;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        procedure CHECK_TBL(prng: inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE) is
            variable rdata : std_logic_vector(WIDTH     -1 downto 0);
        begin
            for i in 0 to N/LANE-1 loop
                TBL_RPTR  <= std_logic_vector(to_unsigned(i*LANE,TBL_RPTR'length));
                WAIT_CLK(2);
                for l in 0 to LANE-1 loop
                    rdata := TBL_RDATA(WIDTH*(l+1)-1 downto WIDTH*l);
                    if (rdata /= std_logic_vector(prng.table(i*LANE+l))) then
                        WRITE(text_line, SPACE & "TBL_RDATA(");
                        WRITE(text_line, i*LANE+l);
                        WRITE(text_line, ")=" & TO_DEC_STRING(unsigned(rdata),10) & " prng.table=(");
                        WRITE(text_line, i*LANE+l);
                        WRITE(text_line, ")=" & TO_DEC_STRING(unsigned(prng.table(i*LANE+l)),10));
                        WRITELINE(OUTPUT, text_line);
                        assert (FALSE) report "Mismatch Initialzed table" severity FAILURE;
                    end if;
                end loop;
                -- WRITE(text_line, TO_DEC_STRING(unsigned(TBL_RPTR ), 6));
                -- WRITE(text_line, SPACE);
                -- WRITE(text_line, TO_DEC_STRING(unsigned(TBL_RDATA),10));
                -- WRITELINE(OUTPUT, text_line);
            end loop;
        end procedure;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        procedure WRITE_TBL(prng: inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE) is
            variable wdata : std_logic_vector(WIDTH*LANE-1 downto 0);
        begin
            for i in 0 to N/LANE-1 loop
                for l in 0 to LANE-1 loop
                    wdata(WIDTH*(l+1)-1 downto WIDTH*l) := std_logic_vector(prng.table(i*LANE+l));
                end loop;
                TBL_WDATA <= wdata;
                TBL_WPTR  <= std_logic_vector(to_unsigned(i*LANE,TBL_WPTR'length));
                TBL_WE    <= (others => '1');
                WAIT_CLK(1);
            end loop;
            TBL_WE    <= (others => '0');
        end procedure;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        procedure CHECK_RND(prng: inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE; count:integer) is
            variable count_run : integer;
            variable count_val : integer;
            variable count_max : integer;
            variable rdata     : std_logic_vector(WIDTH     -1 downto 0);
        begin
            RND_RUN   <= '1';
            count_run := 0;
            count_val := 0;
            count_max := (count/LANE)*LANE-1;
            for i in 0 to RUN_WAIT*(count_max+10) loop
                wait until (CLK'event and CLK = '1');
                if (count_run >= count_max or i mod RUN_WAIT /= 0) then
                    RND_RUN <= '0' after DELAY;
                else
                    RND_RUN <= '1' after DELAY;
                    count_run := count_run + 1;
                end if;
                if (RND_VAL = '1') then
                    for l in 0 to LANE-1 loop
                        count_val := count_val + 1;
                        rdata := RND_NUM(32*(l+1)-1 downto 32*l);
                        WRITE(text_line, TO_DEC_STRING(unsigned(rdata),10));
                        WRITE(text_line, SPACE);
                        GENERATE_RANDOM_STD_LOGIC_VECTOR(prng,vec);
                        assert (rdata = vec)
                            report "Mismatch Random Number (" &
                                   TO_DEC_STRING(to_unsigned(count_val,10),4,'0') & ") " &
                                   TO_DEC_STRING(unsigned(rdata),10) & " /= " &
                                   TO_DEC_STRING(unsigned(  vec),10)
                            severity FAILURE;
                        if (count_val mod 5 = 0) then
                            WRITELINE(OUTPUT, text_line);
                        end if;
                    end loop;
                    if (count_val > count_max) then
                        exit;
                    end if;
                end if;
            end loop;
            WRITELINE(OUTPUT, text_line);
            RND_RUN  <= '0' after DELAY;
        end procedure;
    begin
        RST       <= '1';
        TBL_INIT  <= '0';        
        TBL_WE    <= (others => '0');
        TBL_WPTR  <= (others => '0');
        TBL_WDATA <= (others => '0');
        TBL_RPTR  <= (others => '0');
        RND_RUN   <= '0';
        WAIT_CLK(10);
        RST       <= '0';
        WAIT_CLK(10);

        WRITE(text_line, TAG & "check prgn_1.table");
        WRITELINE(OUTPUT, text_line);
        WAIT_CLK(1);
        TBL_INIT <= '1';
        CHECK_TBL(prng_1);
        WAIT_CLK(10);
        TBL_INIT <= '0';

        WRITE(text_line, TAG & "1000 outputs of genrand_int32()");
        WRITELINE(OUTPUT, text_line);
        CHECK_RND(prng_1, 1000);

        WRITE(text_line, TAG & "write prng_2.table");
        WRITELINE(OUTPUT, text_line);
        TBL_INIT  <= '1';
        WAIT_CLK(1);
        WRITE_TBL(prng_2);
        WRITE(text_line, TAG & "check prng_2.table");
        WRITELINE(OUTPUT, text_line);
        WAIT_CLK(1);
        CHECK_TBL(prng_2);
        WAIT_CLK(10);
        TBL_INIT <= '0';

        WRITE(text_line, TAG & "1000 outputs of genrand_int32()");
        WRITELINE(OUTPUT, text_line);
        CHECK_RND(prng_2, 1000);

        assert(false) report TAG & " Run complete..." severity FAILURE;
        wait;
    end process;
end MODEL;
