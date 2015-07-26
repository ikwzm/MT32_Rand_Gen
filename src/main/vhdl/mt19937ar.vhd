-----------------------------------------------------------------------------------
--!     @file    mt19937ar.vhd
--!     @brief   Pseudo Random Number Generator Package(MT19937AR).
--!     @version 1.0.0
--!     @date    2012/8/1
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
use     ieee.numeric_std.all;
-----------------------------------------------------------------------------------
--! @brief Pseudo Random Number Generator Package(MT19937AR).
--! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--!        This is a Mersenne Twister pseudorandom number generator
--!        with period 2^19937-1 with improved initialization scheme.
-----------------------------------------------------------------------------------
package MT19937AR is
    -------------------------------------------------------------------------------
    --! @brief Type of Random Number.
    -------------------------------------------------------------------------------
    subtype  RANDOM_NUMBER_TYPE   is unsigned(31 downto 0);
    -------------------------------------------------------------------------------
    --! @brief Vector of Random Number.
    -------------------------------------------------------------------------------
    type     RANDOM_NUMBER_VECTOR is array(integer range <>) of RANDOM_NUMBER_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Type of Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    subtype  SEED_TYPE            is unsigned(31 downto 0);
    -------------------------------------------------------------------------------
    --! @brief Vector of Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    type     SEED_VECTOR          is array(integer range <>) of SEED_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Convert Integer to SEED_TYPE
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    arg       Integer.
    --! @return             Generated seed number.
    -------------------------------------------------------------------------------
    function TO_SEED_TYPE(arg:integer) return SEED_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Pseudo Random Number Generator State Vector Size.
    -------------------------------------------------------------------------------
    constant STATE_SIZE : integer   := 624;
    -------------------------------------------------------------------------------
    --! @brief Type of Record for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    type     PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE is record
        index   : integer range 0 to STATE_SIZE-1;
        table   : RANDOM_NUMBER_VECTOR(0 to STATE_SIZE-1);
    end record;    
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number Vector for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(seed:SEED_VECTOR) return PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(seed:integer    ) return PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable seed      : in    SEED_VECTOR
    );
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable seed      : in    integer
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (std_logic_vector).
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_STD_LOGIC_VECTOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   std_logic_vector
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,0x7fffffff]-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_INT31(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   integer
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1]-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL1(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL2(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL3(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    );
end MT19937AR;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
package body MT19937AR is
    -------------------------------------------------------------------------------
    -- Period parameters
    -------------------------------------------------------------------------------
    constant M          : integer            := 397;
    constant MATRIX_A   : RANDOM_NUMBER_TYPE := X"9908B0DF";
    constant UPPER_MASK : RANDOM_NUMBER_TYPE := (RANDOM_NUMBER_TYPE'high => '1', others => '0');
    constant LOWER_MASK : RANDOM_NUMBER_TYPE := (RANDOM_NUMBER_TYPE'high => '0', others => '1');
    -------------------------------------------------------------------------------
    --! @brief Convert integer to SEED_TYPE
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    arg       Integer.
    --! @return             Generated seed number.
    -------------------------------------------------------------------------------
    function TO_SEED_TYPE(arg:integer) return SEED_TYPE is
    begin
        return to_unsigned(arg,SEED_TYPE'length);
    end function;
    -------------------------------------------------------------------------------
    --! @brief Convert from integer to RANDOM_NUMBER_TYPE.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    arg       Integer.
    --! @return             Generated seed number.
    -------------------------------------------------------------------------------
    function TO_RANDOM_NUMBER_TYPE(arg:integer) return RANDOM_NUMBER_TYPE is
    begin
        return to_unsigned(arg,RANDOM_NUMBER_TYPE'length);
    end function;
    -------------------------------------------------------------------------------
    --! @brief RANDOM_NUMBER_TYPE multiplied by integer.
    -------------------------------------------------------------------------------
    function MUL_K(k:integer;arg:RANDOM_NUMBER_TYPE) return RANDOM_NUMBER_TYPE is
        variable tmp : unsigned(2*RANDOM_NUMBER_TYPE'length-1 downto 0);
    begin
        tmp := arg * TO_RANDOM_NUMBER_TYPE(k);
        return tmp(RANDOM_NUMBER_TYPE'range);
    end function;
    -------------------------------------------------------------------------------
    --! @brief Convert from RANDOM_NUMBER_TYPE to real number.
    -------------------------------------------------------------------------------
    function TO_REAL(arg:RANDOM_NUMBER_TYPE) return real is
      variable result: real := 0.0;
    begin
        for i in arg'range loop
            result := result + result;
            if (arg(i) = '1') then
                result := result + 1.0;
            end if;
        end loop;
        return result;
    end function;
    -------------------------------------------------------------------------------
    --! @brief Initializes Pseudo Random Number Generator Table with a seed.
    -------------------------------------------------------------------------------
    procedure  init_table(table:inout RANDOM_NUMBER_VECTOR;seed:in RANDOM_NUMBER_TYPE) is
        alias    mt : RANDOM_NUMBER_VECTOR(0 to table'length-1) is table;
        constant K  : integer := 1812433253;
    begin
        mt(0) := seed and X"FFFFFFFF";
        for i in 1 to mt'high loop
            mt(i) := MUL_K(K,(mt(i-1) xor (mt(i-1) srl 30))) + i;
        end loop;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Initializes Pseudo Random Number Generator Table by array.
    -------------------------------------------------------------------------------
    procedure  init_by_array(
        table     : inout RANDOM_NUMBER_VECTOR;
        init_key  : in    SEED_VECTOR
    ) is
        alias    mt : RANDOM_NUMBER_VECTOR(0 to table'length-1) is table;
        alias    ik : SEED_VECTOR(0 to init_key'length-1) is init_key;
        variable i  : integer range mt'low to mt'high;
        variable j  : integer range ik'low to ik'high;
        variable n  : integer;
        constant K1 : integer := 1664525;
        constant K2 : integer := 1566083941;
    begin
        init_table(table, TO_RANDOM_NUMBER_TYPE(19650218));
        i := 1;
        j := 0;
        if (mt'length > ik'length) then
            n := mt'length;
        else
            n := ik'length;
        end if;
        for count in n downto 1 loop
            mt(i) := (mt(i) xor MUL_K(K1,(mt(i-1) xor (mt(i-1) srl 30)))) + ik(j) + j;
            if (i >= mt'high) then
                mt(0) := mt(mt'high);
                i := 1;
            else
                i := i + 1;
            end if;
            if (j >= ik'high) then
                j := 0;
            else
                j := j + 1;
            end if;
        end loop;
        for count in mt'high downto 1 loop
            mt(i) := (mt(i) xor MUL_K(K2,(mt(i-1) xor (mt(i-1) srl 30)))) - i;
            if (i >= mt'high) then
                mt(0) := mt(mt'high);
                i := 1;
            else
                i := i + 1;
            end if;
        end loop;
        mt(0) := X"80000000";
    end init_by_array;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number word.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    result    Generated random number word.
    -------------------------------------------------------------------------------
    procedure generate_word(
        variable generator  : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable result     : out   RANDOM_NUMBER_TYPE
    ) is
        alias    mt         :       RANDOM_NUMBER_VECTOR(0 to generator.table'length-1) is generator.table;
        variable i          :       integer range mt'low to mt'high;
        variable x0,x1,xm   :       RANDOM_NUMBER_TYPE;
        variable y          :       RANDOM_NUMBER_TYPE;
        variable z          :       RANDOM_NUMBER_TYPE;
        constant mag01      :       RANDOM_NUMBER_VECTOR(0 to 1) := (0 => X"00000000", 1 => MATRIX_A);
    begin
        i  := generator.index;
        x0 := mt(i);
        x1 := mt((i+1) mod mt'length);
        xm := mt((i+M) mod mt'length);
        y  := (x0 and UPPER_MASK) or (x1 and LOWER_MASK);
        z  := xm xor (y srl 1) xor mag01(to_integer(y mod mag01'length));
        mt(i) := z;
        generator.index := (i+1) mod mt'length;
        y  := z;
        y  := y xor ((y srl 11));
        y  := y xor ((y sll  7) and X"9d2c5680");
        y  := y xor ((y sll 15) and X"efc60000");
        y  := y xor ((y srl 18));
        result := y;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(seed:SEED_VECTOR) return PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    is
        variable generator : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    begin
        generator.index := 0;
        init_by_array(generator.table, seed);
        return generator;
    end function;
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(seed:integer    ) return PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    is
        variable generator : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    begin
        generator.index := 0;
        init_table(generator.table, TO_SEED_TYPE(seed));
        return generator;
    end function;
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable seed      : in    SEED_VECTOR
    ) is
    begin 
        generator.index := 0;
        init_by_array(generator.table, seed);
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable seed      : in    integer
    ) is
    begin 
        generator.index := 0;
        init_table(generator.table, TO_SEED_TYPE(seed));
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (std_logic_vector).
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_STD_LOGIC_VECTOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   std_logic_vector
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
        variable number_t  :       std_logic_vector(number'length-1 downto 0);
    begin
        generate_word(generator, word);
        for i in number_t'range loop
            if (word(i) = '1') then
                number_t(i) := '1';
            else
                number_t(i) := '0';
            end if;
        end loop;  
        number := number_t;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,0x7fffffff]-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_INT31(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   integer
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        generate_word(generator, word);
        number := to_integer(word(31 downto 1));
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1]-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL1(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        generate_word(generator, word);
        number := (1.0/4294967295.0)*TO_REAL(word);
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL2(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        generate_word(generator, word);
        number := (1.0/4294967296.0)*TO_REAL(word);
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL3(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        generate_word(generator, word);
        number := (1.0/4294967296.0)*(0.5+TO_REAL(word));
    end procedure;
end MT19937AR;
