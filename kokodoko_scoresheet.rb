#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'

o=ARGV[0].to_i

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
  '第36回' => 'lists/kd_winner_36.txt',
  '第37回' => 'lists/kd_winner_37.txt',
  '第38回' => 'lists/kd_winner_38.txt',
  '第39回' => 'lists/kd_winner_39.txt',
  '第41回' => 'lists/kd_winner_41.txt',
  '第42回' => 'lists/kd_winner_42.txt',
  '第43回' => 'lists/kd_winner_43.txt',
  '第45回' => 'lists/kd_winner_45.txt',
  '第46回' => 'lists/kd_winner_46.txt',
  '第47回' => 'lists/kd_winner_47.txt',
  '第49回' => 'lists/kd_winner_49.txt',
  '第50回' => 'lists/kd_winner_50.txt',
  '第51回' => 'lists/kd_winner_51.txt',
}

file_list.each {|no, fname|
  next if o == 0 and fname =~ /ki|sp/
  next if o == 1 and fname =~ /ki/
  File.open(fname) {|file|
    a[no] = file.read.
            gsub(/（\d{4}\/\d{1,2}\/\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2}）/, ''). # メール到着時刻を除去
            gsub(/&amp;/, '&'). # &amp; は & に変換
            gsub(/\n/, '') # 改行を除去
  }
}


da=[]
h=Hash.new{|h,k|h[k]={}}

#read nayose
nr = CSV.read("./nayose.csv")

nrr = {}
nr.map{|t|y=t.shift;t.map{|s|nrr[s]=y}}

#newer sort
a.to_a.reverse.map{|d,s|
  da << d
  s.split("／").map.with_index(1){|n,i|
    n.lstrip!
    ndup=n.dup
    nrr.map{|x,y|
      if n==x and da.first==d then STDERR.puts d+" "+x+"→"+y end
      next n.sub!(x,y) if n==x
    }
    if !h[n].key?(d) then
      h[n][d]=i
    else
      STDERR.puts "dup! #{d}  #{n} : #{i} > #{h[n][d]}"
      nrr.map{|x,y|
        if ndup==x then STDERR.puts x+"→"+y end
      }
    end
  }
}

if ARGV[1] == "sort" then
#name sort
  h.map{|n,k|
    s=n.dup
    [s,k.values_at(*da),k.size]
  }.sort_by{|s|
    s.first.tr('ァ-ン','ぁ-ん').tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
      .tr('★','').tr('☆','').tr('●','').tr('▲','').tr('◆','').tr('◇','')
      .tr('♪','').tr('■','').tr('※','').tr('！','').tr('？','')
      .tr('◎','').tr('△','').tr('　','').tr(' ','').tr('?','').tr('〓','')
      .tr('∴','').tr('[','').tr('【','').tr('「','').tr('@','')
      .downcase
  }.map{|s|
    if s[1].first != nil and s.last == 1 then
      s << "#####new#####"
    end
    puts s.join(',')
  }
elsif ARGV[1] == "json" then
  puts '{"data":['
  h.sort_by.with_index{|s,i|
    [s[1].values_at,i]
  }.map.with_index(1){|m,i|
    n, k = m
    s=n.dup
    kk = k.values_at(*da).map{|e| e ? e : ""}
    print ([s]+kk+[k.size]).to_s.gsub!(/, /,',')
    print "," if i != h.size
    print "\n"
  }
  puts ']}'
else
  sep  = ARGV[1] == "table" ? '|' : ','
  ends = ARGV[1] == "table" ? '|' : ''
  quo  = ARGV[1] == "table" ? '' : '"'
  puts sep+''+sep+da.join(sep)+sep if ARGV[1] == "table"
  puts (sep+"---")*(da.size+1)+sep if ARGV[1] == "table"
  #newer sort
  h.sort_by.with_index{|s,i|
    [s[1].values_at,i]
  }.map{|n,k|
    s=n.dup
    # rr.map{|x,y|
    #   s.gsub!(x,y)
    # }
    s = "'"+s if /^[0-9]+$/ =~ s # 数値だけの場合 ' を先頭に付ける
    puts ends+"#{quo}"+s+"#{quo}"+sep+[k.values_at(*da),k.size].join(sep)+ends
  }

end
