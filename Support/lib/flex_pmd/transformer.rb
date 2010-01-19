#!/usr/bin/env ruby -wKU
# encoding: utf-8

# == Overview
#
# Convert a PMD report file to html using xslt.
#
# The bundle follows a predefined set of rules, as such it expects that the xslt
# file be located <tt>{TM_BUNDLE_SUPPORT}/etc/pmd.xslt</tt> and the flex.pmd
# report file is in <tt>{TM_PROJECT_DIRECTORY}/reports/flexpmd/pmd.xml</tt>.
#
# Users can override the default locations by setting the +TM_FLEXPMD_REPORT_XSLT+
# and +TM_FLEXPMD_REPORT+ environmental variables.
#
class Transformer

  attr_reader :xslt,
              :report

  # Initialise an object instance. Where alternative xslt and pmd report files 
  # are required override the +x+ and +r+ parameters with the relevant file paths.
  #
  def initialize(x=nil,r=nil)
    @xslt   = x.nil? ? default_xsl : x
    @report = r.nil? ? default_rep : r
  end

  # Outputs the report in html.
  #
  def run
    if File.exist? report
      `xsltproc "#{xslt}" "#{report}"`
    else
      puts "<h1>Error</h1><p>The required pmd.xml report file was not found.</p>"
    end
  end

  protected

  # Returns the user defined file path if available, otherwise falls back to the
  # default file path for the flex pmd xslt transformation file.
  #
  def default_xsl
    return ENV['TM_FLEXPMD_REPORT_XSLT'] unless ENV['TM_FLEXPMD_REPORT_XSLT'].nil?
    ENV['TM_BUNDLE_SUPPORT']+'/etc/pmd.xslt'
  end
  
  # Returns the user defined file path if available, otherwise falls back to the
  # default file path for the flex pmd report file.
  #
  def default_rep
    return ENV['TM_FLEXPMD_REPORT'] unless ENV['TM_FLEXPMD_REPORT'].nil?
    ENV['TM_PROJECT_DIRECTORY']+'/reports/flexpmd/pmd.xml'
  end

end

if __FILE__ == $0

  require "test/unit"
  
  # Tests cases for the Transformer classes.
  #
  class TestTransformer < Test::Unit::TestCase
    
    # Path to the bundle support directory.
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
