-----------------------------------------------------------------------------------
--!     @file    mt32_rand_gen.vhd
--!     @brief   Pseudo Random Number Generator (MT32)
--!     @version 0.1.0
--!     @date    2015/6/26
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
entity  MT32_RAND_GEN is
    generic (
        SEED        : integer := 123;
        L           : integer := 1
    );
    port (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        TBL_INIT    : in  std_logic;
        TBL_WE      : in  std_logic_vector(   L-1 downto 0);
        TBL_WPTR    : in  std_logic_vector(    15 downto 0);
        TBL_WDATA   : in  std_logic_vector(32*L-1 downto 0);
        TBL_RPTR    : in  std_logic_vector(    15 downto 0);
        TBL_RDATA   : out std_logic_vector(32*L-1 downto 0);
        RND_RUN     : in  std_logic;
        RND_VAL     : out std_logic;
        RND_NUM     : out std_logic_vector(32*L-1 downto 0)
    );
end     MT32_RAND_GEN;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of MT32_RAND_GEN is
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant  N                : integer := 624;
    constant  M                : integer := 397;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant  WIDTH            : integer := 32;
    subtype   RANDOM_NUMBER_TYPE   is std_logic_vector(WIDTH-1 downto 0);
    type      RANDOM_NUMBER_VECTOR is array(integer range <>) of RANDOM_NUMBER_TYPE;
    constant  UPPER            : std_logic_vector(WIDTH-1 downto WIDTH-1) := (others => '1');
    constant  LOWER            : std_logic_vector(WIDTH-2 downto       0) := (others => '1');
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant  MATRIX_A         : RANDOM_NUMBER_TYPE := X"9908B0DF";
    constant  TEMPERING_PARAM1 : RANDOM_NUMBER_TYPE := X"9d2c5680";
    constant  TEMPERING_PARAM2 : RANDOM_NUMBER_TYPE := X"efc60000";
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    function  shift(arg: RANDOM_NUMBER_TYPE;num:integer) return RANDOM_NUMBER_TYPE is
        variable retval : RANDOM_NUMBER_TYPE;
    begin
        for i in retval'range loop
            if (i+num <= retval'high and i+num >= retval'low) then
                retval(i) := arg(i+num);
            else
                retval(i) := '0';
            end if;
        end loop;
        return retval;
    end function;
    function  shift_right(arg: RANDOM_NUMBER_TYPE;num:positive) return RANDOM_NUMBER_TYPE is
    begin
        return shift(arg,num);
    end function;
    function  shift_left (arg: RANDOM_NUMBER_TYPE;num:positive) return RANDOM_NUMBER_TYPE is
    begin
        return shift(arg,-num);
    end function;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    function  Tempering(arg: RANDOM_NUMBER_TYPE) return RANDOM_NUMBER_TYPE is
      variable y      : RANDOM_NUMBER_TYPE;
    begin
        y := arg;
        y := y xor (shift_right(y, 11));
        y := y xor (shift_left (y,  7) and TEMPERING_PARAM1);
        y := y xor (shift_left (y, 15) and TEMPERING_PARAM2);
        y := y xor (shift_right(y, 18));
        return  y;
    end function;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    function  CALC_MT_PTR_LOW return integer is
        variable retval : integer;
    begin
        retval := 0;
        while (2**retval < L) loop
            retval := retval + 1;
        end loop;
        return retval;
    end function;
    function  CALC_MT_PTR_HIGH return integer is
        variable retval : integer;
    begin
        retval := 0;
        while (2**(retval+1) < N) loop
            retval := retval + 1;
        end loop;
        return retval;
    end function;
    constant  MT_PTR_LOW           : integer := CALC_MT_PTR_LOW;
    constant  MT_PTR_HIGH          : integer := CALC_MT_PTR_HIGH;
    subtype   MT_PTR_TYPE         is std_logic_vector(MT_PTR_HIGH downto MT_PTR_LOW);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    function  TO_MT_PTR(arg:integer) return MT_PTR_TYPE is
        variable u : unsigned(MT_PTR_HIGH downto 0);
    begin
        u := to_unsigned(arg,u'length);
        return std_logic_vector(u(MT_PTR_TYPE'range));
    end function;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    function  INC_MT_PTR(ptr:MT_PTR_TYPE) return MT_PTR_TYPE is
        variable retval : MT_PTR_TYPE;
    begin
        if (unsigned(ptr) >= unsigned(TO_MT_PTR(N-1))) then
            retval := (others => '0');
        else
            retval := std_logic_vector(unsigned(ptr)+1);
        end if;
        return retval;
    end function;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    random_number        : RANDOM_NUMBER_VECTOR(0 to L-1);
    signal    random_valid         : std_logic;
    signal    z_val                : std_logic;
    signal    z                    : RANDOM_NUMBER_VECTOR(0 to L-1);
    signal    mt_mdata             : RANDOM_NUMBER_VECTOR(0 to L-1);
    signal    mt_xdata             : RANDOM_NUMBER_VECTOR(0 to L-1);
    signal    mt_wdata             : RANDOM_NUMBER_VECTOR(0 to L-1);
    signal    mt_rdata             : RANDOM_NUMBER_VECTOR(0 to L-1);
    signal    mt_waddr             : MT_PTR_TYPE;
    signal    mt_write             : std_logic_vector    (0 to L-1);
    signal    mt_read              : std_logic;
    signal    mt_curr_xaddr        : MT_PTR_TYPE;
    signal    mt_next_xaddr        : MT_PTR_TYPE;
    signal    mt_curr_maddr        : MT_PTR_TYPE;
    signal    mt_next_maddr        : MT_PTR_TYPE;
    signal    x_curr_index         : MT_PTR_TYPE;
    signal    x_next_index         : MT_PTR_TYPE;
    signal    m_curr_index         : MT_PTR_TYPE;
    signal    m_next_index         : MT_PTR_TYPE;
    signal    z_curr_index         : MT_PTR_TYPE;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    component MT32_RAND_RAM
        generic(
            DEPTH : integer;
            L_SIZE: integer;
            L_NUM : integer;
            SEED  : integer;
            ID    : integer
        );
        port (
            CLK   : in  std_logic;
            WE    : in  std_logic;
            WADDR : in  std_logic_vector(DEPTH-1 downto 0);
            WDATA : in  std_logic_vector(     31 downto 0);
            RADDR : in  std_logic_vector(DEPTH-1 downto 0);
            RDATA : out std_logic_vector(     31 downto 0)
        );
    end component;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    CTRL: process(CLK,RST) begin
        if (RST = '1') then
                x_curr_index <= TO_MT_PTR(0);
                x_next_index <= TO_MT_PTR(0);
                m_curr_index <= TO_MT_PTR(M);
                m_next_index <= TO_MT_PTR(M);
                z_curr_index <= TO_MT_PTR(0);
                mt_read      <= '0';
                z_val        <= '0';
        elsif (CLK'event and CLK = '1') then
            if    (TBL_INIT='1') then
                x_curr_index <= TO_MT_PTR(0);
                x_next_index <= TO_MT_PTR(0);
                m_curr_index <= TO_MT_PTR(M);
                m_next_index <= TO_MT_PTR(M);
                z_curr_index <= TO_MT_PTR(0);
                mt_read      <= '0';
                z_val        <= '0';
            else
                if (RND_RUN = '1')then
                    x_curr_index <= x_next_index;
                    x_next_index <= INC_MT_PTR(x_next_index);
                    m_curr_index <= m_next_index;
                    m_next_index <= INC_MT_PTR(m_next_index);
                    mt_read      <= '1';
                else
                    mt_read      <= '0';
                end if;
                if (mt_read = '1') then
                    z_curr_index <= x_curr_index;
                    z_val        <= '1';
                else
                    z_val        <= '0';
                end if;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    mt_waddr      <= z_curr_index when (TBL_INIT='0') else TBL_WPTR(MT_PTR_TYPE'range);
    mt_curr_xaddr <= x_curr_index when (TBL_INIT='0') else TBL_RPTR(MT_PTR_TYPE'range);
    mt_next_xaddr <= x_next_index when (TBL_INIT='0') else TBL_RPTR(MT_PTR_TYPE'range);
    mt_curr_maddr <= m_curr_index when (TBL_INIT='0') else TBL_RPTR(MT_PTR_TYPE'range);
    mt_next_maddr <= m_next_index when (TBL_INIT='0') else TBL_RPTR(MT_PTR_TYPE'range);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    GEN:for i in 0 to L-1 generate
        signal mg : RANDOM_NUMBER_TYPE;
    begin
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        mt_write(i) <= z_val when (TBL_INIT='0') else TBL_WE(i);
        mt_wdata(i) <= z(i)  when (TBL_INIT='0') else TBL_WDATA(WIDTH*(i+1)-1 downto WIDTH*i);
        TBL_RDATA(WIDTH*(i+1)-1 downto WIDTH*i) <= mt_rdata(i);
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        MT_X_U:if (i = 0) generate
          signal mt_curr_upper : std_logic_vector(UPPER'range);
        begin 
            U:MT32_RAND_RAM
                generic map(
                    DEPTH => MT_PTR_TYPE'length,
                    L_SIZE=> L,
                    L_NUM => i,
                    SEED  => SEED,
                    ID    => i
                )
                port map (
                    CLK   => CLK,
                    WE    => mt_write(0),
                    WADDR => mt_waddr,
                    WDATA => mt_wdata(0),
                    RADDR => mt_next_xaddr,
                    RDATA => mt_rdata(0)
                );
            process (CLK, RST) begin
                if (RST = '1') then
                    mt_curr_upper <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if (mt_read = '1') then
                        mt_curr_upper <= mt_rdata(i)(UPPER'range);
                    end if;
                end if;
            end process;
            mt_xdata(0  )(UPPER'range) <= mt_curr_upper;
            mt_xdata(L-1)(LOWER'range) <= mt_rdata(0)(LOWER'range);
        end generate;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        MT_X_M: if (i > 0) generate
            U: MT32_RAND_RAM
                generic map(
                    DEPTH => MT_PTR_TYPE'length,
                    L_SIZE=> L,
                    L_NUM => i,
                    SEED  => SEED,
                    ID    => i
                )
                port map (
                    CLK   => CLK,
                    WE    => mt_write(i),
                    WADDR => mt_waddr,
                    WDATA => mt_wdata(i),
                    RADDR => mt_curr_xaddr,
                    RDATA => mt_rdata(i)
                );
            mt_xdata(i  )(UPPER'range) <= mt_rdata(i)(UPPER'range);
            mt_xdata(i-1)(LOWER'range) <= mt_rdata(i)(LOWER'range);
        end generate;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        MT_M:block
            signal mt_maddr : MT_PTR_TYPE;
        begin
            mt_maddr <= mt_curr_maddr when (i >= (M mod L)) else
                        mt_next_maddr;
            U: MT32_RAND_RAM
                generic map(
                    DEPTH => MT_PTR_TYPE'length,
                    L_SIZE=> L,
                    L_NUM => i,
                    SEED  => SEED,
                    ID    => L+i
                )
                port map (
                    CLK   => CLK,
                    WE    => mt_write(i),
                    WADDR => mt_waddr,
                    RADDR => mt_maddr,
                    WDATA => mt_wdata(i),
                    RDATA => mt_mdata((L+i-(M mod L)) mod L)
                );
        end block;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        mg   <= MATRIX_A when (mt_xdata(i)(0) = '1') else (others => '0');
        z(i) <= mt_mdata(i) xor shift_right(mt_xdata(i),1) xor mg;
        random_number(i) <= Tempering(z(i));
    end generate;
    random_valid <= z_val;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process(CLK,RST) begin
        if (RST = '1') then
            RND_VAL <= '0';
            RND_NUM <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            RND_VAL <= random_valid;
            for i in 0 to L-1 loop
                RND_NUM(WIDTH*(i+1)-1 downto WIDTH*i) <= random_number(i);
            end loop;
        end if;
    end process;
end RTL;
