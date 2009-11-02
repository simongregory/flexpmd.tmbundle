#!/usr/bin/env ruby -wKU

module FlexPMD

  class Tool
    
    attr_reader :jar
    
    attr_accessor :src,
                  :report,
                  :ruleset,
                  :doc
                  
    def initialize(doc_only=false)
      @doc      = doc_only
      @jar      = e_sh("#{bundle_root}/jar/flex-pmd-command-line-1.0.Rc4.jar")
      @src      = doc == true ? e_sh(File.dirname(ENV['TM_FILEPATH'])) : e_sh(ENV['TM_PROJECT_DIRECTORY']+'/src')
      @report   = e_sh(ENV['TM_PROJECT_DIRECTORY']+'/reports/flexpmd')
      @ruleset  = ENV['TM_FLEXPMD_RULESET']
    end
    
    def cmd
      c = "java -Xms64m -Xmx768m -jar #{jar} -s #{src} -o #{report}"
      c += "-r #{e_sh(ruleset)}" if ruleset
      c
    end
    
    def run
      
      puts '<h1>Running...</h1>'
      puts '<div class="runner"><span class="showhide">'
      puts "<a href=\"javascript:hideElement('runner')\" id='runner_h' style=''>&#x25BC;</a>"
      puts "<a href=\"javascript:showElement('runner')\" id='runner_s' style='display: none;'>&#x25B6;</a>"
      puts '</span></div>'
      puts '<div class="inner" id="runner_b" style=""><br/>'
      puts "<code>#{cmd}</code><br/>"
      puts '<code>'

      TextMate::Process.run(cmd) do |str|
        STDOUT << str
      end

      puts '</code>'
      puts '</div>'
      
    end

    protected
    
    def bundle_root
      File.expand_path(File.dirname(__FILE__)+'/../../')
    end
    
  end
end

if __FILE__ == $0

require "test/unit"

class TestTool < Test::Unit::TestCase
  def test_case_name
    assert_equal(true, false)
  end
end
end