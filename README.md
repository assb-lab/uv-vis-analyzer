# UV-VIS Analyzer

Igor Pro 8 用の手順ファイルです。UV-VIS の反射スペクトルから Kubelka-Munk 関数 F(R) と Tauc プロットを描き、バンドギャップを見積もります。

ドキュメント: [UV-VIS Analyzer](https://assb-lab.github.io/uv-vis-analyzer/)

## 動作環境

Igor Pro 8

## バージョン

バージョンは `uv_vis_analyzer.ipf` の `ksUVVisAnalyzerVersion` です。現在は `0.1.0` です。

マクロを開くと、パネルタイトルが `UV-VIS-Analyzer v0.1.0` になります。

## 読み込み

### macOS でエイリアスを置く

リポジトリのルートで次を実行します。

```sh
./scripts/install_igor_alias.sh
```

`ksUVVisAnalyzerVersion` からエイリアス名を作り、Finder エイリアスを次のフォルダに置きます。

`~/Documents/WaveMetrics/Igor Pro 8 User Files/Igor Procedures/`

バージョン `0.1.0` のときの名前は `uv_vis_analyzer_v_0_1_0.ipf` です。参照先はこのリポジトリの `uv_vis_analyzer.ipf` です。

同じフォルダに他の `uv_vis_analyzer_v_*` があるときはパスを表示し、削除してよいかを尋ねます。`y` または `はい` のときだけ削除します。

Igor を起動し直すか、手順をコンパイルし直してください。メニュー **Macros > 🔦 UV-VIS Analyzer** でパネルが開きます。

### 手順ファイルを直接開く

Igor で `uv_vis_analyzer.ipf` を開き、コンパイルします。その後、**Macros > 🔦 UV-VIS Analyzer** を選びます。

## 入力ファイル

**Load UV-VIS spectra (*.txt)** は、カンマ区切りのテキストを読みます。

- 1列目: 波長 (nm)
- 2列目: 反射率 (%)
- 先頭2行は読み飛ばします

反射率 R は百分率として扱い、Kubelka-Munk 関数は次のとおりです。

F(R) = (1 - R)^2 / (2R)

光子エネルギーは E (eV) = 1239.84 / λ (nm) です。

## グラフ

読み込むと、同じ大きさのグラフが4つ開きます。どれにもカーソル A、B、C、D が付きます。

| 位置 | ウィンドウ | 横軸 |
| --- | --- | --- |
| 上段左 | `kubelka_munk_vs_photon_energy` | Photon energy hν / eV |
| 上段右 | `kubelka_munk_vs_wavelength` | Wavelength λ / nm |
| 下段左 | `tauc_plot_direct` | Photon energy hν / eV |
| 下段右 | `tauc_plot_indirect` | Photon energy hν / eV |

上段の縦軸は F(R) です。下段の direct は (F(R)·hν)^2、indirect は (F(R)·hν)^(1/2) です。

## バンドギャップ

パネルは3列です。計算は、最前面のグラフにあるカーソルを使います。

| 列 | グラフ上のラベル |
| --- | --- |
| Band Gap | `E_g = <値> eV` |
| Direct Band Gap | `E_g,direct = <値> eV` |
| Indirect Band Gap | `E_g,indirect = <値> eV` |

各列の操作は同じです。

1. 対象のグラフを前面にする
2. 吸収端にカーソル A と B、バックグラウンドにカーソル C と D を置く
3. **Cursor(A, B)** で吸収端を直線フィットする
4. **Cursor(C, D)** でバックグラウンドを直線フィットする。水平なゼロを使うときは **Zero Line**
5. **Calculate** で2本の直線の交点をバンドギャップにする

値はパネルの各列と、グラフ左上のテキストボックスに出ます。
