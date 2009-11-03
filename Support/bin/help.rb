#!/usr/bin/env ruby -wKU
# encoding: utf-8

require ENV['TM_SUPPORT_PATH'] + '/lib/escape'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/web_preview'

BUNDLE_ROOT = File.expand_path(File.dirname(__FILE__)+'/../')

jar = e_sh("#{BUNDLE_ROOT}/jar/flex-pmd-command-line-1.0.Rc4.jar")
cmd = "java -jar #{jar}"

puts html_head( :window_title => "FlexPMD Help",
                :page_title => "FlexPMD Help")

puts "<h2>FlexPMD Help</h2>"
puts "<p><a href='http://opensource.adobe.com/wiki/display/flexpmd/FlexPMD/'>FlexPMD</a> bundle is work in progress.</p>"
puts "<h3>Compiler Options:</h3>"
puts "<pre>"

TextMate::Process.run(cmd) do |str|
  STDOUT << str
end

puts "</pre>"

html_footer
