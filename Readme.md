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

* 同期双方向メモリモデル sdpram.vhd (<https://github.com/ikwzm/PipeWork.git>)
* XILINX社FPGA用として   sdpram_xilinx_auto_select.vhd (<https://github.com/ikwzm/PipeWork.git>)

論理合成は Xilinx 社 ISE13.1 使いました。

Altera社のFPGAで合成を行うためには次のファイルが必要です。

* 同期双方向メモリモデル sdpram.vhd (<https://github.com/ikwzm/PipeWork.git>)
* ALTERA社FPGA用として   sdpram_altera_auto_select.vhd (<https://github.com/ikwzm/PipeWork.git>)

###シミュレーション###
シミュレーションをするためには次のファイルが必要です。

* 擬似乱数生成パッケージ mt19937ar.vhd (<https://github.com/ikwzm/Dummy_Plug)
* 同期双方向メモリモデル sdpram.vhd sdpram_model.vhd (<https://github.com/ikwzm/PipeWork.git>)

Altera社のFPGA用にシミュレーションするには次のファイルが必要です。

* altera_mf.vhd                 (Altera社の開発ツールに含まれています)
* altera_mf_components.vhd      (Altera社の開発ツールに含まれています)

シミュレーションには GHDL (http://ghdl.free.fr/) を使いました。
Makefile を用意したので、make コマンド一発でシミュレーションが走ります。
もしかしたら他のシミュレーションでは走らないかもしれません。その際はご一報ください。

###その他###
なおここにアップした回路は乱数生成のみで、テーブルの初期化は行っていません。
テーブルの初期化は、外部から書き込むか、FPGAベンダーのツールを使ってあらかじめRAMに書いておく必要があります。
テーブルの初期化のための回路を作ることも考えましたが、たかだか１回の初期化のために貴重なFPGA/ASICのリソースを使うのもなんだし、んなもんCPUでやればいいやってことで今回は見送りました。
もう少しパーシャルリコンフィグが使い易ければ、初期化のあとにリソースを開放して他の機能に置き換えることが出来るんですが。

###ライセンス###
二条項BSDライセンス (2-clause BSD license) で公開しています。

###謝辞###
それにしても、このような貴重なアルゴリズムを惜しげもなく公開してくださった方々にはひたすら感謝です。
