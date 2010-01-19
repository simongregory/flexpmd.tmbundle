#!/usr/bin/env ruby -wKU
# encoding: utf-8

# = Overview
#
# Quick script to provide some help for the flexpmd tool. It may be usefull in
# the future to plumb this into the bundle help command. For now hit CMD-R for a
# list of available options.
#

$: << File.expand_path(ENV['TM_SUPPORT_PATH'] + '/lib/')
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'tm/process'
require 'textmate'
require 'web_preview'
require 'flex_pmd/tool'

# NOTE: Commented out for now.
#
# puts html_head( :window_title => "FlexPMD Help",
#                 :page_title => "FlexPMD Help")
# 
# puts "<h2>FlexPMD Help</h2>"
# puts "<p><a href='http://opensource.adobe.com/wiki/display/flexpmd/FlexPMD/'>FlexPMD</a> bundle is work in progress.</p>"
# puts "<h3>Compiler Options:</h3>"
# puts "<pre>"

tool = FlexPMD::Tool.new
tool.show_options

# puts "</pre>"
# 
# html_footer
