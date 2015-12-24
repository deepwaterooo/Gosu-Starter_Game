#!/usr/bin/ruby

$: << File.dirname(__FILE__)

require 'gosu'
require 'rubygems'
include Gosu

require 'editor/EditorWindow.rb'
require 'editor/SceneEditor.rb'

$window = EditorWindow.new
$window.show
