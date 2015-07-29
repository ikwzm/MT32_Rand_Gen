library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MT32_RAND_GEN;
entity  SAMPLE is
    generic (L: integer := 1);
    port    (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        RND_RUN     : in  std_logic;
        RND_OUT     : out std_logic_vector(31 downto 0)
    );
end     SAMPLE;
architecture RTL of SAMPLE is
    constant   INIT_SEED   :  integer   := 123;
    constant   tbl_init    :  std_logic := '0';
    constant   tbl_we      :  std_logic_vector(   L-1 downto 0) := (others => '0');
    constant   tbl_wptr    :  std_logic_vector(    15 downto 0) := (others => '0');
    constant   tbl_wdata   :  std_logic_vector(32*L-1 downto 0) := (others => '0');
    constant   tbl_rptr    :  std_logic_vector(    15 downto 0) := (others => '0');
    signal     tbl_rdata   :  std_logic_vector(32*L-1 downto 0);
    signal     rnd_val     :  std_logic;
    signal     rnd_num     :  std_logic_vector(32*L-1 downto 0);
    signal     rnd_reg     :  std_logic_vector(32*L-1 downto 0);
begin
    U: entity MT32_RAND_GEN.MT32_RAND_GEN
        generic map(
            SEED        => INIT_SEED,
            L           => L
        )
        port map(
            CLK         => CLK      ,
            RST         => RST      ,
            TBL_INIT    => tbl_init ,
            TBL_WE      => tbl_we   ,
            TBL_WPTR    => tbl_wptr ,
            TBL_WDATA   => tbl_wdata,
            TBL_RPTR    => tbl_rptr ,
            TBL_RDATA   => tbl_rdata,
            RND_RUN     => RND_RUN  ,
            RND_VAL     => rnd_val  ,
            RND_NUM     => rnd_num
        );
    process(CLK,RST) begin
        if (RST = '1') then
                rnd_reg <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if  (rnd_val = '1') then
                rnd_reg <= rnd_num;
            elsif (L > 1) then
                for i in 0 to L-2 loop
                    rnd_reg(32*i+31 downto 32*i) <= rnd_reg(32*(i+1)+31 downto 32*(i+1));
                end loop;
            end if;
        end if;
    end process;
    RND_OUT <= rnd_reg(31 downto 0);
end  RTL;
