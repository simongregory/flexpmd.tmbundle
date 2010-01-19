#!/usr/bin/env ruby -wKU
# encoding: utf-8

# =Overview
#
# Command line access to the transformer tool to enable the conversion of a
# flexpmd report document to a TextMate html output window.
#

$: << File.expand_path(ENV['TM_SUPPORT_PATH'] + '/lib/')
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'escape'
require 'flex_pmd/transformer'
require 'web_preview'

puts html_head( :window_title => "FlexPMD",
                :page_title => "FlexPMD Report",
                :sub_title => "pmd.xml" )

p = Transformer.new
puts p.run

html_footer
