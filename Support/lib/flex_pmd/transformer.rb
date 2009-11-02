#!/usr/bin/env ruby -wKU

# Convert a PMD report file to html using xslt.
#
class Transformer

  attr_reader :xslt,
              :report

  def initialize(x=nil,r=nil)
    @xslt   = x.nil? ? default_xsl : x
    @report = r.nil? ? default_rep : r
  end

  def run
    if File.exist? report
      `xsltproc "#{xslt}" "#{report}"`
    else
      puts "<h1>Error</h1><p>The required pmd.xml report file was not found.</p>"
    end
  end

  protected

    def default_xsl
      return ENV['TM_FLEXPMD_REPORT_XSLT'] unless ENV['TM_FLEXPMD_REPORT_XSLT'].nil?
      ENV['TM_BUNDLE_SUPPORT']+'/etc/pmd.xslt'
    end

    def default_rep
      return ENV['TM_FLEXPMD_REPORT'] unless ENV['TM_FLEXPMD_REPORT'].nil?
      ENV['TM_PROJECT_DIRECTORY']+'/reports/flexpmd/pmd.xml'
    end

end

if __FILE__ == $0

  require "test/unit"

  class TestTransformer < Test::Unit::TestCase

    def bundle_support
      File.expand_path(File.dirname(__FILE__)+'/../')
    end

    def test_case_name

      x = "#{bundle_support}/etc/pmd.xslt"
      r = "#{bundle_support}/test/pmd.xml"

      p = Transformer.new(x,r)
      puts p.run

    end

  end

end
