#!/usr/bin/env ruby -wKU
# encoding: utf-8

module FlexPMD

  # Ruby wrapper for the FlexPMD build tool.
  #
  # Output is specifically formatted in html for use in TextMate.
  #
  class Tool

    attr_reader :jar

    attr_accessor :src,
      :report,
      :ruleset,
      :doc
    
    # Object initialisation. To flag that output should be shown only for a single
    # file set +doc_only+ to +true+.
    #
    def initialize(doc_only=false)
      @doc      = doc_only
      @jar      = e_sh("#{bundle_root}/jar/flex-pmd-command-line-1.0.Rc4.jar")
      @src      = doc == true ? e_sh(File.dirname(ENV['TM_FILEPATH'])) : e_sh(ENV['TM_PROJECT_DIRECTORY']+'/src')
      @report   = e_sh(ENV['TM_PROJECT_DIRECTORY']+'/reports/flexpmd')
      @ruleset  = e_sh(find_ruleset)
    end
    
    # The command to execute as a string, with the custom ruleset specified if
    # set by the user.
    #
    def cmd
      c = "java -Xms64m -Xmx768m -jar #{jar} -s #{src} -o #{report}"
      c += " -r #{ruleset}" unless ruleset == "''"
      c
    end
    
    # Runs the currently configured pmd task and prints formatted html output. 
    #
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
    
    # Prints a javascript request to hide command output. This can be used during
    # the execution to hide the raw output.
    #
    def hide_output
      puts "<script>javascript:hideElement('runner')</script>"
    end
    
    # Prints the currently available flexpmd compiler options to screen.
    #
    def show_options
      TextMate::Process.run("java -jar #{jar}") do |str|
        STDOUT << str
      end
    end

    protected
    
    # Path to the bundle support directory.
    #
    def bundle_root
      File.expand_path(File.dirname(__FILE__)+'/../../')
    end
    
    # Attempts to locate the flex pmd ruleset file.
    #
    # Returns the path as a string if found, otherwise an empty string.
    #
    def find_ruleset
      rs = ENV['TM_FLEXPMD_RULESET'] || false
      pd = ENV['TM_PROJECT_DIRECTORY'] || false

      if rs
        return rs if File.exist?(rs)
      end

      if rs && pd
        return "#{pd}/#{rs}" if File.exist?("#{pd}/#{rs}")
      end

      ''
    end

  end
end

if __FILE__ == $0

  require "test/unit"
  
  # Tests cases for the Tool class.
  #
  class TestTool < Test::Unit::TestCase
    def test_case_name
      assert_equal(true, false)
    end
  end
end
