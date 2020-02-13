BIOTITE - MAX10 FPGA CARD
=========================

Overview
--------
<img src="https://raw.githubusercontent.com/osafune/biotite/master/img/biotite_image.png" width="600" height="512">

BOTITE（ビオタイト）はクレジットカードサイズのMAX10 FPGAカードです。84mm×53mm×2.6mmの超薄型サイズでいつも財布の中に入れておけます。
オンボードにはタクタイルスイッチ、7セグ配置のLED、USB-Blaster互換機能として使用可能なUSBマイコンを搭載しています。
Type-Cのカードエッジコネクタの他、シングルラインのPMODが接続できるI/Oコネクタを3箇所に用意しており学習用に最適です。


Board Layout
------------
<img src="https://raw.githubusercontent.com/osafune/biotite/master/img/biotite_layout.png" width="608" height="359">

- MAX10 10M08SCE144C8G
	- デバイスパッケージ:EQFP144
	- ロジック数:8000LE
	- メモリマクロ:42個(387kbit ※初期値ロード機能なし)
	- Flashメモリ:ユーザー領域32kバイト(UFM0+UFM1)、コンフィグレーション用140kバイト(CFM0)
	- 乗算器:24個(18x18bit)
	- I/O数:最大101本
	- 内蔵PLL:1個
	- 内蔵OSC:1個
	- 内蔵ADC:なし
	- デュアルコンフィグレーション機能:なし

- Lyonteck LY68L6400(ES)
	- デバイスパッケージ:SOIC-8 (150mil)
	- メモリ:64Mbit PSRAM
	- I/F:SPIまたはQSPI(最大108MHz ※ES品のため一部QSPIでのREADができません)


Documents
---------
- [QuartusPrime LiteEdition ダウンロード](https://fpgasoftware.intel.com/?edition=lite)
- [Intel MAX10 FPGAのドキュメント](https://www.intel.co.jp/content/www/jp/ja/programmable/products/fpga/max-series/max-10/support.html)


Contant Us
----------
- [GitHub - Shun OSAFUNE](https://github.com/osafune)
- [Twitter - @s_osafune](https://twitter.com/s_osafune)

