#!/usr/bin/ruby
# coding: utf-8

require 'levenshtein'

a = []
STDIN.each_line {|l|
  a << l.split(',').first
}

b = []
a.combination(2).each{|n, m|
  lev = Levenshtein.distance n, m.tr('ァ-ン','ぁ-ん').tr("０-９Ａ-Ｚａ-ｚ　", "0-9A-Za-z ")
                                .tr('★','').tr('☆','').tr('●','').tr('▲','').tr('◆','')
                                .tr('♪','').tr('■','').tr('※','').tr('！','').tr('？','')
  print "#{lev}: #{n} <=> #{m}\n" if lev < 3 and n.size > 4
}
