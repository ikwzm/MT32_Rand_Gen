#Mersenne Twister Pseudo Random Number Generator


##Overview


###Introduction


このIPはMersenne Twister法による疑似乱数生成回路です。

こちらを参考に書いてみました。Mersenne Twister HomePage (http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/mt.html)

mt19937arを元にしています。


###Features


* Mersenne Twister法による疑似乱数生成回路です。

* VHDLで記述しています。

* 論理合成可能です。

* １クロックで1、2、3、8、16ワード(1ワードは32bit)の乱数を生成します。

* ジェネリック変数でSEED値を設定できます。

* 状態テーブルを変更することが可能です。


![Fig.1 外観](./readme.img/akgeo1.jpg "Fig.1 外観")

Fig.1 外観

<br />


###Licensing


二条項BSDライセンス (2-clause BSD license) で公開しています。



##Specification


###Parameter Descriptions


Table.1 Parameter Descriptions

<table border="2">
  <tr>
    <td align="center">Name</td>
    <td align="center">TYPE</td>
    <td align="center">Default</td>
    <td align="center">Description</td>
  </tr>
  <tr>
    <td>LANE</td>
    <td align="center">Integer</td>
    <td align="center">1</td>
    <td>1クロックで生成する乱数の数を指定します。<br />このパラメータで指定できる数は、1、2、4、8、16のいずれかです。</td>
  </tr>
  <tr>
    <td>SEED</td>
    <td align="center">Integer</td>
    <td align="center">-</td>
    <td>乱数のシード値を指定します。</td>
  </tr>
</table>




###Port Descriptions


Table.2 Port  Descriptions

<table border="2">
  <tr>
    <td align="center">Name</td>
    <td align="center">Type</td>
    <td align="center">Width</td>
    <td align="center">I/O</td>
    <td align="center">Description</td>
  </tr>
  <tr>
    <td>CLK</td>
    <td align="center">STD_LOGIC</td>
    <td align="center">1</td>
    <td align="center">in</td>
    <td>クロック信号</td>
  </tr>
  <tr>
    <td>RST</td>
    <td align="center">STD_LOGIC</td>
    <td align="center">1</td>
    <td align="center">in</td>
    <td>非同期リセット信号<br />注)状態テーブルの内容はリセットしません</td>
  </tr>
  <tr>
    <td>RND_RUN</td>
    <td align="center">STD_LOGIC</td>
    <td align="center">1</td>
    <td align="center">in</td>
    <td>乱数生成開始信号<br />この信号が\'1\'になってから３クロック後に乱数を出力します<br />TBL_INITが\'1\'の時、この信号を\'1\'にしてはいけません</td>
  </tr>
  <tr>
    <td>RND_VAL</td>
    <td align="center">STD_LOGIC</td>
    <td align="center">1</td>
    <td align="center">out</td>
    <td>乱数有効信号<br />RND_NUMより生成された乱数が有効であることをしめす信号<br />RND_RUNが\'1\'になってから3クロック後に\'1\'になります</td>
  </tr>
  <tr>
    <td>RND_NUM</td>
    <td align="center">STD_LOGIC_VECTOR</td>
    <td align="center">32*LANE</td>
    <td align="center">out</td>
    <td>乱数出力信号<br />生成された乱数を出力する信号<br />RND_RUNが\'1\'になってから３クロック後に乱数を出力します</td>
  </tr>
  <tr>
    <td>TBL_INIT</td>
    <td align="center">STD_LOGIC</td>
    <td align="center">1</td>
    <td align="center">in</td>
    <td>状態テーブル・初期化信号<br />状態テーブルを初期化することを示します<br />この信号が\'1\'の時のみ、TBL_*信号は有効です</td>
  </tr>
  <tr>
    <td>TBL_WE</td>
    <td align="center">STD_LOGIC_VECTOR</td>
    <td align="center">1*LANE</td>
    <td align="center">in</td>
    <td>状態テーブル・ライト信号<br />状態テーブルへのライトを示す信号<br />ライトはワード(32bit)単位で行います</td>
  </tr>
  <tr>
    <td>TBL_WPTR</td>
    <td align="center">STD_LOGIC_VECTOR</td>
    <td align="center">16</td>
    <td align="center">in</td>
    <td>状態テーブル・ライトアドレス<br />状態テーブルへのライトアドレスをワード(32bit)単位で示します<br />例えば、LANE=2の場合下位1ビットは無視されます</td>
  </tr>
  <tr>
    <td>TBL_WDATA</td>
    <td align="center">STD_LOGIC_VECTOR</td>
    <td align="center">32*LANE</td>
    <td align="center">in</td>
    <td>状態テーブル・ライトデータ<br />状態テーブルへのライトデータをLSBで入力します</td>
  </tr>
  <tr>
    <td>TBL_RPTR</td>
    <td align="center">STD_LOGIC_VECTOR</td>
    <td align="center">16</td>
    <td align="center">in</td>
    <td>状態テーブル・リードアドレス<br />状態テーブルからのリードアドレスをワード(32bit)単位で示します<br />例えば、LANE=2の場合下位1ビットは無視されます</td>
  </tr>
  <tr>
    <td>TBL_RDATA</td>
    <td align="center">STD_LOGIC_VECTOR</td>
    <td align="center">32*LANE</td>
    <td align="center">out</td>
    <td>状態テーブル・リードデータ<br />状態テーブルからのリードデータ<br />TBL_RPTRの入力に対して１クロック後にTBL_RPTRで示したアドレスの値を出力します</td>
  </tr>
</table>




![Fig.2 Generate Timing (LANE=1)](./readme.img/akgeo2.jpg "Fig.2 Generate Timing (LANE=1)")

Fig.2 Generate Timing (LANE=1)

<br />


![Fig.3 Generate Timing (LANE=4)](./readme.img/akgeo3.jpg "Fig.3 Generate Timing (LANE=4)")

Fig.3 Generate Timing (LANE=4)

<br />



##Simulation


###GHDLによるシミュレーション


####GHDLのバージョン


GHDLのバージョンは0.29です。

GHDLのホームページはこちら(http://ghdl.free.fr)


####Makefile


シミュレーション用に Makefile を用意しています。


```Makefile:Makefile
GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=work
TEST_BENCH = test_bench \\
             $(END_LIST)
all: $(TEST_BENCH)
clean:
	rm -f *.o *.cf $(TEST_BENCH)
test_bench: mt19937ar.o test_bench.o mt32_rand_gen.o mt32_rand_ram.o
	 $(GHDL) -e $(GHDLFLAGS) $@
	-$(GHDL) -r $(GHDLRUNFLAGS) $@
test_bench.o    :  ../../src/test/vhdl/test_bench.vhd mt32_rand_gen.o
	$(GHDL) -a $(GHDLFLAGS) --work=work $<
mt32_rand_gen.o :  ../../src/main/vhdl/mt32_rand_gen.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<
mt32_rand_ram.o:  ../../src/main/vhdl/mt32_rand_ram.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<
mt19937ar.o    :  ../../src/main/vhdl/mt19937ar.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=mt32_rand_gen $<

```



####シミュレーションの実行



```Shell
$ cd sim/ghdl
$ cd make
ghdl -a --mb-comments --work=mt32_rand_gen ../../src/main/vhdl/mt19937ar.vhd
ghdl -a --mb-comments --work=mt32_rand_gen ../../src/main/vhdl/mt32_rand_gen.vhd
ghdl -a --mb-comments --work=work ../../src/test/vhdl/test_bench.vhd
ghdl -a --mb-comments --work=mt32_rand_gen ../../src/main/vhdl/mt32_rand_ram.vhd
ghdl -e --mb-comments test_bench
ghdl -r  test_bench
../../../src/ieee/numeric_std-body.v93:2098:7:@0ms:(assertion warning): NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
../../../src/ieee/numeric_std-body.v93:2098:7:@0ms:(assertion warning): NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
 check prgn_1.table
 1000 outputs of genrand_int32()
2991312382 3062119789 1228959102 1840268610  974319580 
2967327842 2367878886 3088727057 3090095699 2109339754 
1817228411 3350193721 4212350166 1764906721 2941321312 
	:
	(中略)
	:
../../src/test/vhdl/test_bench.vhd:297:9:@51680ns:(assertion failure):   Run complete...
./test_bench:error: assertion failed
./test_bench:error: simulation failed
ghdl: compilation error
```


最後にエラーが出てるように見えますが、これはassert(FALSE)でシミュレーションを終了しているためです。





###Vivadoによるシミュレーション


####Vivadoのバージョン


Vivado 2015.1


####Vivado プロジェクトの作成


すでにプロジェクトを作っている場合は省略してください。

プロジェクトを生成するためのTclスクリプト(create_project.tcl)を用意しています。

cd fpga/xilinx/vivado2015.1/mt32_rand_gen

Vivado > Tools > Run Tcl Script > create_project.tcl   



####シミュレーションを実行


Vivado > Open Project > mt32_rand_gen.xpr

Flow Navigator > Run Simulation > Run Behavioral Simulation




##Synthesis and Implementation


###Vivadoによる論理合成


####Vivadoのバージョン


Vivado 2015.1


####Vivado プロジェクトの作成


すでにプロジェクトを作っている場合は省略してください。

プロジェクトを生成するためのTclスクリプト(create_project.tcl)を用意しています。

デバイスはとりあえずxc7a15tcsg324-3を指定しますが、変更したい場合は、create_project.tcl を修正してください。



cd fpga/xilinx/vivado2015.1/mt32_rand_gen

Vivado > Tools > Run Tcl Script > create_project.tcl


####Synthesis


Flow Navigator > Run Synthesis


####Implementation


Flow Navigator > Run Implementation






##Acknowledgments


それにしても、このような貴重なアルゴリズムを惜しげもなく公開してくださった方々にはひたすら感謝です。

