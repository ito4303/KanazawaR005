##
## Kanazawa.R #5 初心者向けチュートリアル
## 2025年5月30日
##

# 電卓としてつかう

1 + 2
3 - 4
5 * 6
7 / 8

# べき乗

2^3
2 ** 3

# 関数を使う

sqrt(4)    # sqrt()は平方根を返す関数

?sqrt      # sqrt()のヘルプを表示
help(sqrt) # これでも同じ

log(100)                # log()は自然対数を返す関数
log10(100)              # log10()は常用対数を返す関数
log(x = 100, base = 10) # これでも同じ
?log                    # log()のヘルプを表示

log(100, 10)            # 順番どおりなら、引数名は省略できる
log(base = 10, 100)     # 引数名を指定すれば、順番は違ってよい
log(b = 10, 100)        # 引数名はほかと重ならなければ、途中まででもよい
                        # といっても、あとでわかりにくくなるので、
                        # なるべく順番どおりにするか、省略しないほうがよい

# ベクトル

c(1, 2, 3) # c()はベクトルを作る関数

1:10       # コロン(:)で連続する整数のベクトルをつくれる

c("AB", "CD", "EF") # 文字列のベクトル

# 代入

X <- c("AB", "CD", "EF") # Xという変数に代入

# Rでは変数宣言は不要

# 変数の内容を表示

X
print(X) # print()関数で明示的に表示

# 代入は"="でもよい

X = c("GH", "IJ", "KL")
X

# 逆向きの代入

c("abc", "def", "ghi") -> X
X

# カッコで囲むと代入と表示を同時にできる

(X <- 1:10)

# ベクトルの要素を取り出す

X[1]   # 1番目の要素（Rの添え字は1から始まります）
X[5:6] # 5-6番目の要素

# データフレーム型
# 表形式のデータ
# 列（縦の並び）が変数、行（横の並び）が個々の観測となる

member <- data.frame(name = c("鈴木", "佐藤", "田中", "山田"),
                     age = c(20, 30, 37, 43),
                     height = c(170, 160, 180, 165))
member

# 列（変数）を取り出す

member$name      # name列を取り出す
member[, 1]      # これでも同じ（Rの添え字は1から始まります）
member[, "name"] # これでも同じ
member[, 2:3]    # 第2〜3列を取り出す

# 行（観測）を取り出す

member[2, ]                     # 2行目を取り出す
member[member$name == "佐藤", ] # nameが佐藤の行を取り出す
                                # tidyverseだとよりわかりやすい書き方（あとで）
member[member$age >= 30, ]      # ageが30以上の行を取り出す

# 列と行を指定して値を取り出す

member[2, "name"] # 2行目のname列を取り出す
member[2, 1]      # これでも同じ
member$name[2]    # これでも同じ


#
# 制御フロー
#

# 条件分岐

x <- 1
y <- 2

if (x > y) {
  print("xはyより大きい.")
} else {
  print("xはyより大きくない.")
}

# ループ

for (i in 1:9) {
  print(i)
}


for(a in c("A", "B", "x", "y")) {
  b <- paste0(a, "0")   # paste0()は文字列を連結する関数
  print(b)
}

z <- 10
while(z > 0) {
  z <- z - 1
  print(z)
}

# Rでは、ループを使うよりベクトルとして処理する方が効率的
# 例 ベクトルの要素それぞれに1をたす

(a <- seq(0, 1, by = 0.1)) # 0から1まで0.1きざみベクトルを生成

b <- c()                 # 空のベクトルを生成
for (i in seq_along(a))  # seq_along()はベクトルのインデックスを返す
  b[i] <- a[i] + 1
b

# ベクトルで処理する

rm("b")  # いったんbを消去

# 各要素に1をたす

(b <- a + 1)


# スカラー倍

(c <- a * 2)

# 和

b + c

# 要素ごとの積

b * c

# 関数の引数にベクトル

exp(a)
log(b)

# もっと複雑な場合にはapply系関数やpurrrパッケージの関数
# 今回は説明しません


#
# 記述統計
#

set.seed(123) # 擬似乱数の固定

# 平均0、標準偏差1の正規分布にしたがう乱数を100個生成
# rnorm()は正規乱数を生成する関数

x <- rnorm(100, mean = 0, sd = 1)

# 各種統計関数

mean(x)     # 平均
median(x)   # 中央値
var(x)      # 不偏分散
sd(x)       # 標準偏差（不偏分散の平方根）
quantile(x) # 四分位数



#
# パッケージの利用とTidy data
#

# tidyverseパッケージがインストールされているか
# チェックする
# ※これは通常はしなくてよい

if (requireNamespace("tidyverse", quietly = TRUE)) {
  # requireNamespace()は、パッケージがインストール
  # されているかどうかを返す関数

  # tidyverseパッケージがインストールされているとき
  print("tidyverseがインストールされています")
} else {
  # tidyverseパッケージをインストールされていなければインストールする
  # （依存パッケージもまとめてインストールする）
  # 基本的にインストールは1回だけすればよい
  #（Rをバージョンアップしたら、再度必要な場合も）
  install.packages("tidyverse", dependencies = TRUE)
  # install.packagesはパッケージをインストールする関数
}

# tidyverseパッケージを読み込む

library(tidyverse)

# データの読み込み

# スライド資料の気温データをファイルにしておきました

file_path <- file.path("data", "kion.tsv")
             # file.path()はファイルパスを作る関数

# ファイルを読み込む

Kion <- readr::read_tsv(file_path)
        # read_tsv()はタブ区切りのデータを読み込む関数
Kion # 読み込んだデータを表示

# Tidy dataに変換
# pivot_longer()は、tidyrパッケージの関数で、データを縦長に変換する

Kion_long <- Kion |>
  pivot_longer(cols = starts_with(c("max", "min")),
               # "max"または"min"で始まる列を
               # 変換の対象とする
               names_to = c("item", "date"),
               # 変換した列の名前を"item"と"date"にする
               names_sep = "_",
               # 列名中の"_"を区切り文字とする
               values_to = "temperature")
               # 値の列名を"temperature"にする

Kion_long # 変換したデータを表示

# 最高気温と最低気温は別の変数であると考えるなら、それぞれを別の列にしたい
# pivot_wider()は、tidyrパッケージの関数で、データを横長に変換する

Kion_long |>
  pivot_wider(names_from = "item",
              # "item"列の内容を新しい列の名前に
              values_from = "temperature")
              # "temperature"列の内容を新しい列の値に

# "|>"はパイプ演算子と呼ばれ、左側の式の値を右側の関数の第1引数として渡すもの
# magrittrパッケージの %>% も（だいたい）同じ

# パイプ演算子の使い方
# 平方根の和の自然対数を求めるといった場合
# 関数をネストすると だんだんわかりにくくなってくる

log(sum(sqrt(X)))

# パイプ演算子を使うと

X |>
  sqrt() |>
  sum() |>
  log()

# データの変換に戻って
# 縦長にしたデータをもとにもどす

Kion_long |>
  pivot_wider(names_from = c("item", "date"),
              # "item"と"date"列の内容を新しい列の名前に
              values_from = "temperature")
              # "temperature"列の内容を新しい列の値に


#
# パッケージをつかった例
#

# setariaviridis は、エノコログサ(Setaria viridis)の測定データを収めた
# パッケージ

# setariaviridisパッケージがインストールされていなければ
# インストールする

if (!requireNamespace("setariaviridis", quietly = TRUE)) {
  install.packages("setariaviridis")
}
# '!'は、TRUE/FALSEを反転させる演算子

library(setariaviridis) # library関数でパッケージを読み込む
help(setariaviridis) # パッケージのヘルプを表示

View(setaria_viridis)    # データを表計算ソフトのように表示

summary(setaria_viridis) # データの要約を表示

glimpse(setaria_viridis) # データの構造を表示
                         # glimpse()はdplyrパッケージの関数

# dplyrパッケージを使ったデータの抽出

setaria_viridis |>
  dplyr::pull(culm_length) |>  # culm_length列を抽出
  mean()                       # 平均

# パッケージ名::関数名 と書くと、library()でパッケージを読み込んで
# おかなくても関数を使用できる
# また、ほかのパッケージと関数名がかぶるときに、どのパッケージの関数か
# 明示的に指定できる
# dplyrは、割とほかのパッケージと関数名がかぶりがちなので、明示的に
# 指定する場合が多いようだ

setaria_viridis |>
  dplyr::filter(culm_length > 60) # culm_lengthが60より大きいデータを抽出

# さっきのmembersデータフレームであった例

member[member$name == "佐藤", ] # nameが佐藤の行を取り出す

member |>
  dplyr::filter(name == "佐藤") # tidyverseのdplyrをつかう書き方

member |>
  dplyr::filter(name == "佐藤" | name == "鈴木") |>
  dplyr::select(age) # nameが佐藤または鈴木の行を取り出して、age列を抽出

member |>
  dplyr::filter(name == "佐藤" | name == "鈴木") |>
  dplyr::pull(age) # pull()はベクトルとして抽出

member |>
  dplyr::select(2) # 2列目を抽出

member |>
  dplyr::slice(2)  # 2行目を抽出

#
# グラフの作成
#

# ggplot2パッケージを使ったグラフの描画
# ggplot2パッケージはtidyverseに含まれている

help(ggplot2) # ggplot2のヘルプを表示

# culm_lengthを横軸に、panicle_lengthを縦軸にした散布図を描く

# ggplot関数で、ggplotオブジェクトを作成
# "+"でレイヤーを追加していく

ggplot(data = setaria_viridis,
       mapping = aes(x = culm_length, y = panicle_length)) +
  geom_point() + # 散布図
  labs(title = "Setaria viridis", # タイトル
       x = "Culm length (cm)",    # X軸ラベル
       y = "Panicle length (cm)") # Y軸ラベル

# デフォルトのbaseグラフィックスなら

plot(x = setaria_viridis$culm_length,
     y = setaria_viridis$panicle_length,
     type = "p",
     main = "Setaria viridis",
     xlab = "Culm length (cm)", ylab = "Panicle length (cm)")

# あるいは

plot(panicle_length ~ culm_length, data = setaria_viridis,
     type = "p",
     main = "Setaria viridis",
     xlab = "Culm length (cm)", ylab = "Panicle length (cm)")

# ggplot2に戻ります
# 根株ごとに色を変える
# いったんオブジェクトに保存

p <- ggplot(data = setaria_viridis,
       mapping = aes(x = culm_length, y = panicle_length,
                     colour = factor(root_number))) +
  geom_point(size = 3) +  # 点のサイズを変える
  labs(title = "Setaria viridis",
       x = "Culm length (cm)", y = "Panicle length (cm)",
       colour = "Root number")

# オブジェクトに保存しておいたものを表示

plot(p)

# これでもよい

print(p)

# これでも

p

# ラベルを日本語に
# テーマとフォントを変更

p +
  labs(title = "エノコログサ",
       x = "稈長 (cm)", y = "花序長 (cm)",
       colour = "株番号") +
  theme_classic(base_family = "YuGothic", base_size = 16)
