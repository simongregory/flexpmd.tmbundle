#!/usr/bin/env ruby -wKU
# encoding: utf-8

module FlexPMD
  
  # Class to encapsulate configuration settings. This class is awaiting integration
  # into the project.
  #
  class Settings
    
    # Returns the path to the pmd xlst document.
    #
    def xslt
      return ENV['TM_FLEXPMD_REPORT_XSLT'] unless ENV['TM_FLEXPMD_REPORT_XSLT'].nil?
      ENV['TM_BUNDLE_SUPPORT']+'/etc/pmd.xslt'
    end

    # Returns the path to the pmd xml report document.
    #
    def report
      return ENV['TM_FLEXPMD_REPORT'] unless ENV['TM_FLEXPMD_REPORT'].nil?
      ENV['TM_PROJECT_DIRECTORY']+'/report/flexpmd/pmd.xml'
    end

    # Returns the path to the pmd ruleset document.
    #
    def ruleset
      return ENV['TM_FLEXPMD_RULESET'] unless ENV['TM_FLEXPMD_RULESET'].nil?
      nil
    end
    
    # Returns a boolean to indicate if the user is working within a TextMate
    # project.
    #
    def has_tm_proj?
      return !ENV['TM_PROJECT_DIRECTORY'].nil?
    end

  end

end

if __FILE__ == $0

  require "test/unit"
  
  # Tests cases for the Settings class.
  #
  class TestSettings < Test::Unit::TestCase
    def test_settings
      s = FlexPMD::Settings.new

      assert_equal(true, s.has_tm_proj?)
      assert_equal(nil, s.ruleset)

      assert_equal(ENV['TM_PROJECT_DIRECTORY']+'/report/flexpmd/pmd.xml', s.report)
      assert_equal(ENV['TM_BUNDLE_SUPPORT']+'/etc/pmd.xslt', s.xslt)

      ENV['TM_FLEXPMD_RULESET'] = 'fake/path/rules.xml'

      assert_equal('fake/path/rules.xml', s.ruleset)

      ENV['TM_FLEXPMD_REPORT'] = 'fake/path/pmd.xml'

      assert_equal('fake/path/pmd.xml', s.report)

      ENV['TM_FLEXPMD_REPORT_XSLT'] = 'fake/path/pmd.xslt'

      assert_equal('fake/path/pmd.xslt', s.xslt)
    end
  end

end
