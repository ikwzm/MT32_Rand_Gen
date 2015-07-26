Mersenne Twister Pseudo Random Number Generator VHDL RTL.
---------------------------------------------------------

###概要###
Mersenne Twister法による擬似乱数生成回路です。

こちらを参考に書いてみました。
Mersenne Twister Home Page (http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/mt.html)

mt19937arを元にしています。

論理合成可能です。

１クロックで１、２、４、８、１６ワード(１ワードは32bit)の乱数を生成できます。

###論理合成###
Xilinx社のFPGAで合成を行うためには次のファイルが必要です。

* 擬似乱数生成パッケージ mt19937ar.vhd (<https://github.com/ikwzm/Dummy_Plug)

###シミュレーション###
シミュレーションをするためには次のファイルが必要です。

* 擬似乱数生成パッケージ mt19937ar.vhd (<https://github.com/ikwzm/Dummy_Plug)

シミュレーションには GHDL (http://ghdl.free.fr/) を使いました。
Makefile を用意したので、make コマンド一発でシミュレーションが走ります。
もしかしたら他のシミュレーションでは走らないかもしれません。その際はご一報ください。

###ライセンス###
二条項BSDライセンス (2-clause BSD license) で公開しています。

###謝辞###
それにしても、このような貴重なアルゴリズムを惜しげもなく公開してくださった方々にはひたすら感謝です。
