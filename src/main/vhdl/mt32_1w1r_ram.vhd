-----------------------------------------------------------------------------------
--!     @file    mt32_1w1r_ram.vhd
--!     @brief   Synchronous Dual Port RAM for MT32_GEN
--!     @version 0.0.5
--!     @date    2012/8/31
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2012 Ichiro Kawazome
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
entity  MT32_1W1R_RAM is
    generic (
        DEPTH : integer := 6;
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
end     MT32_1W1R_RAM;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library PipeWork;
use     PipeWork.COMPONENTS.SDPRAM;
architecture RTL of MT32_1W1R_RAM is
    signal wen : std_logic_vector(0 downto 0);
begin
    wen <= (others => '1') when (WE = '1') else (others => '0');
    RAM:SDPRAM
        generic map(
            DEPTH   => DEPTH+5,
            RWIDTH  => 5,
            WWIDTH  => 5,
            WEBIT   => 0,
            ID      => ID
        )
        port map(
            WCLK    => CLK,
            WE      => wen,
            WADDR   => WADDR,
            RCLK    => CLK,
            RADDR   => RADDR,
            WDATA   => WDATA,
            RDATA   => RDATA
        );
end RTL;
