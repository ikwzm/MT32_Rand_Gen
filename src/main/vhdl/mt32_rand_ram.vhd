-----------------------------------------------------------------------------------
--!     @file    mt32_rand_ram.vhd
--!     @brief   Synchronous Dual Port RAM for MT32_GEN
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
entity  MT32_RAND_RAM is
    generic (
        DEPTH : integer := 6;
        L_SIZE: integer := 1;
        L_NUM : integer := 0;
        SEED  : integer := 123;
        ID    : integer := 0 
    );
    port (
        CLK   : in  std_logic;
        WE    : in  std_logic;
        WADDR : in  std_logic_vector(DEPTH-1 downto 0);
        RADDR : in  std_logic_vector(DEPTH-1 downto 0);
        WDATA : in  std_logic_vector(     31 downto 0);
        RDATA : out std_logic_vector(     31 downto 0)
    );
end     MT32_RAND_RAM;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MT32_RAND_GEN;
use     MT32_RAND_GEN.MT19937AR.PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
use     MT32_RAND_GEN.MT19937AR.NEW_PSEUDO_RANDOM_NUMBER_GENERATOR;
architecture RTL of MT32_RAND_RAM is
    type     RAM_TYPE is array(integer range <>) of std_logic_vector(31 downto 0);

    function RAM_INIT return RAM_TYPE is
        variable prng :  PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE := NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(SEED);
        variable ram  :  RAM_TYPE(0 to 2**DEPTH-1);
    begin
        for i in ram'range loop
            if (i*L_SIZE+L_NUM <= prng.table'high) then
                ram(i) := std_logic_vector(prng.table(i*L_SIZE+L_NUM));
            else
                ram(i) := (others => '0');
            end if;
        end loop;
        return ram;
    end function;

    signal   ram      :  RAM_TYPE(0 to 2**DEPTH-1) := RAM_INIT;
begin
    process (CLK) begin
        if (CLK'event and CLK = '1') then
            if (WE = '1') then
                ram(to_integer(unsigned(WADDR))) <= WDATA;
            end if;
            RDATA <= ram(to_integer(unsigned(RADDR)));
        end if;
    end process;
end RTL;
