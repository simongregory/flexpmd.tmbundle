#!/usr/bin/env ruby -wKU
# encoding: utf-8

$: << File.expand_path(ENV['TM_SUPPORT_PATH'] + '/lib/')
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'textmate'
require 'tm/process'
require 'web_preview'

require 'flex_pmd/transformer'
require 'flex_pmd/tool'

doc_only = (ARGV[0].to_s == 'document') ? true : false
tool = FlexPMD::Tool.new( doc_only )

puts html_head( :window_title => "FlexPMD",
                :page_title => "FlexPMD" )

tool.run

puts "<br/><hr/>"

if tool.doc

  puts "<h1>Results</h1>"

  require 'flex_pmd/report'

  pmd = FlexPmd::Report.new(File.new("#{tool.report}/pmd.xml"))
  puts pmd.single_file_report(ENV['TM_FILEPATH'])

else

  p = Transformer.new
  puts p.run

end

tool.hide_output

html_footer
