#!/usr/bin/env ruby -wKU

$: << File.expand_path(ENV['TM_SUPPORT_PATH'] + '/lib/')
$: << File.expand_path(File.dirname(__FILE__)+'/../lib')

#require 'escape' is used but requried by one of the support lib files.
require 'pmd_to_html'
require 'textmate'
require 'tm/process'
require 'web_preview'

BUNDLE_ROOT = File.expand_path(File.dirname(__FILE__)+'/../')

doc = (ARGV[0].to_s == 'document') ? true : false

jar   = e_sh("#{BUNDLE_ROOT}/jar/flex-pmd-command-line-1.0.Rc4.jar")
src   = doc ? e_sh(File.dirname(ENV['TM_FILEPATH'])) : e_sh(ENV['TM_PROJECT_DIRECTORY']+'/src')
rep   = e_sh(ENV['TM_PROJECT_DIRECTORY']+'/reports/flexpmd')
rules = ENV['TM_FLEXPMD_RULESET'] 

cmd = "java -Xms64m -Xmx768m -jar #{jar} -s #{src} -o #{rep}"
cmd += "-r #{e_sh(rules)}" if rules

puts html_head( :window_title => "FlexPMD",
                :page_title => "FlexPMD")

puts '<h1>Running...</h1>'
puts '<div class="runner"><span class="showhide">'
puts "<a href=\"javascript:hideElement('runner')\" id='runner_h' style=''>&#x25BC;</a>"
puts "<a href=\"javascript:showElement('runner')\" id='runner_s' style=\"display: none;\">&#x25B6;</a>"
puts '</span></div>'
puts '<div class="inner" id="runner_b" style=""><br/>'
puts "<code>#{cmd}</code>"
puts '<code>'

TextMate::Process.run(cmd) do |str|
  STDOUT << str
end

puts '</code>'
puts '</div>'

puts "<br/>"
puts "<hr/>"

if doc
  
  puts "<h1>Results</h1>"
  
  require 'flex_pmd'

  pmd = FlexPmd::Report.new(File.new("#{rep}/pmd.xml"))
  puts pmd.single_file_report(ENV['TM_FILEPATH']) 

else

  p = PmdToHTML.new
  puts p.run

end
html_footer
