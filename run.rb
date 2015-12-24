#!/usr/bin/ruby
# -*- coding: gb2312 -*-

#Project: Platformer “FuZeD”
#Start date: 03/05/14
#Author: Piotr Blaut (“Ekhart”)

$:<<File.dirname(__FILE__)
 
require 'rubygems'
require 'gosu'
require 'scripts/GameWindow.rb'
require 'scripts/SceneMap.rb'
require 'scripts/Player.rb'

include Gosu

window = GameWindow.new
window.show
