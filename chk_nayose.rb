#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'

o=ARGV[0].to_i
o=2

# オプション
# 0 : 通常回のみ
# 1 : 通常回＋特別編
# 2 : 通常回＋特別編＋これはいつでしょう？

a={}

file_list = {
  '第1回'  => 'lists/kd_winner_01.txt',
  '第2回'  => 'lists/kd_winner_02.txt',
  '第3回'  => 'lists/kd_winner_03.txt',
  '第5回'  => 'lists/kd_winner_05.txt',
  '第6回'  => 'lists/kd_winner_06.txt',
  '第7回'  => 'lists/kd_winner_07.txt',
  '第8回'  => 'lists/kd_winner_08.txt',
  '第10回' => 'lists/kd_winner_10.txt',
  '第11回' => 'lists/kd_winner_11.txt',
  'いつ第1回' => 'lists/ki_winner_01.txt', # これはいつでしょう？
  'いつ第2回' => 'lists/ki_winner_02.txt', # これはいつでしょう？
  'いつ第3回' => 'lists/ki_winner_03.txt', # これはいつでしょう？
  'KIRIMIちゃん. AB' => 'lists/sp_winner_01.txt',  # ここはどこでしょう？特別編 KIRIMIちゃん.
  'KIRIMIちゃん. CD' => 'lists/sp_winner_02.txt',  # ここはどこでしょう？特別編 KIRIMIちゃん.
  '第13回' => 'lists/kd_winner_13.txt',
  '第14回' => 'lists/kd_winner_14.txt',
  '第15回' => 'lists/kd_winner_15.txt',
  '第16回' => 'lists/kd_winner_16.txt',
  '第18回' => 'lists/kd_winner_18.txt',
  '第19回' => 'lists/kd_winner_19.txt',
  '第20回' => 'lists/kd_winner_20.txt',
  '第21回' => 'lists/kd_winner_21.txt',
  '第23回' => 'lists/kd_winner_23.txt',
  '第24回' => 'lists/kd_winner_24.txt',
  '第25回' => 'lists/kd_winner_25.txt',
  'LIXIL' => 'lists/sp_winner_03.txt',  # LIXIL 特別編
  '第27回' => 'lists/kd_winner_27.txt',
  '第28回' => 'lists/kd_winner_28.txt',
  '第29回' => 'lists/kd_winner_29.txt',
  '第30回' => 'lists/kd_winner_30.txt',
  '第32回' => 'lists/kd_winner_32.txt',
  '第33回' => 'lists/kd_winner_33.txt',
  '第34回' => 'lists/kd_winner_34.txt',
}

dd = {
  '第1回'  => 1,
  '第2回'  => 2,
  '第3回'  => 3,
  '第5回'  => 4,
  '第6回'  => 5,
  '第7回'  => 6,
  '第8回'  => 7,
  '第10回' => 8,
  '第11回' => 9,
  'いつ第1回' => 10,
  'いつ第2回' => 11,
  'いつ第3回' => 12,
  'KIRIMIちゃん. AB' => 13,
  'KIRIMIちゃん. CD' => 14,
  '第13回' => 15,
  '第14回' => 16,
  '第15回' => 17,
  '第16回' => 18,
  '第18回' => 19,
  '第19回' => 20,
  '第20回' => 21,
  '第21回' => 22,
  '第23回' => 23,
  '第24回' => 24,
  '第25回' => 25,
  'LIXIL' => 26,
  '第27回' => 27,
  '第28回' => 28,
  '第29回' => 29,
  '第30回' => 30,
  '第32回' => 31,
  '第33回' => 32,
  '第34回' => 33,
}

file_list.each {|no, fname|
  next if o == 0 and fname =~ /ki|sp/
  next if o == 1 and fname =~ /ki/
  File.open(fname) {|file|
    a[no] = file.read.
            gsub(/（\d{4}\/\d{1,2}\/\d{2}\s+\d{1,2}:\d{1,2}:\d{1,2}）/, ''). # メール到着時刻を除去
            gsub(/&amp;/, '&'). # &amp; は & に変換
            gsub(/\n/, '') # 改行を除去
  }
}


da=[]
h=Hash.new{|h,k|h[k]={}}

#read nayose
nr = CSV.read("./nayose.csv")

nrr = {}
nrfd = {}
nr.map{|t|y=t.shift;nrfd[y]=0;t.map{|s|nrr[s]=y}}

#newer sort
a.to_a.reverse.map{|d,s|
  da << d
  s.split("／").map.with_index(1){|n,i|
    n.lstrip!
    nrfd.map{|t|
      if n==t.first then
        nrfd[n]=dd[d] if nrfd[n] == 0
      end
    }
  }
}

a.to_a.reverse.map{|d,s|
  s.split("／").map.with_index(1){|n,i|
    n.lstrip!
    nrr.map{|x,y|
      if n==x then
#        puts d+" "+x+"→"+y
        if dd[d] > nrfd[y] then
          puts x+" "+d+" > "+y+" "+nrfd[y].to_s
        end
      end
    }
  }
}
