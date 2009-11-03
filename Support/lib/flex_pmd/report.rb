#!/usr/bin/env ruby -wKU
# encoding: utf-8

module FlexPmd

  class Report

    attr_reader :version,
                :files,
                :timestamp

    def initialize(doc)
      @version = 'unkown'
      @timestamp = 'unkown'
      @files = []
      deserialize(doc)
    end

    def to_html
      o = @files.collect { |e| e.to_html }
      "#{o} <br/><h2>Complete.</h2>"
    end

    def single_file_report(path)
      @files.each { |f| return f.to_html if f.path == path }
    end

    protected

      def deserialize(doc)

        require 'rexml/document'

        report = REXML::Document.new(doc)

        node = report.root

        if node.name == 'pmd'

          @version = node.attributes['version']
          @timestamp = node.attributes['timestamp']

          node.elements.each do |child|
            name = child.name()
            @files << ClassFile.new(self,child) if name == 'file'
          end

        end

      end

  end

  class ClassFile

    attr_reader :parent,
                :path,
                :violations

    def initialize(parent,node)
      @parent = parent
      @violations = []
      deserialize(node)
    end

    def to_html
      @violations.collect { |e| e.to_html }
    end

    protected

      def deserialize(node)
        @path = node.attributes['name']
        node.elements.each do |child|
          @violations << Violation.new(self,child) if child.name() == 'violation'
        end
      end

  end

  class Violation

    attr_reader :parent,
                :beginline,
                :endline,
                :begincolumn,
                :endcolumn,
                :rule,
                :rule_set,
                :package,
                :klass,
                :priority,
                :externalInfoUrl,
                :message

    def initialize(parent,node)
      @parent = parent
      deserialize(node)
    end

    def to_html
      "<b>#{priority}</b> <a href='txmt://open?url=file://#{parent.path}&line=#{beginline}' title='#{klass} #{beginline}'>#{klass}</a> #{message}<br/>"
    end

    protected

      def deserialize(node)
        @beginline       = node.attributes['beginline']
        @endline         = node.attributes['endline']
        @begincolumn     = node.attributes['begincolumn']
        @endcolumn       = node.attributes['endcolumn']
        @rule            = node.attributes['rule']
        @rule_set        = node.attributes['rule_set']
        @package         = node.attributes['package']
        @klass           = node.attributes['class']
        @priority        = node.attributes['priority']
        @externalInfoUrl = node.attributes['externalInfoUrl']
        @message         = node.text
      end

  end

end

if __FILE__ == $0

  require "test/unit"

  TEST_XML = '
<pmd version="4.2.1" timestamp="Fri Oct 30 13:00:08 GMT 2009">
  <file name="/Users/simon/Documents/vw/polo-br/src/uk/co/vw/poloFifty/competition/views/components/Bubble.as">

    <violation
      beginline="56"
      endline="56"
      begincolumn="4" 
      endcolumn="4" 
      rule="adobe.ac.pmd.rules.component.AddChildNotInCreateChildren"
      ruleset="Custom component rules"
      package="uk.co.vw.poloFifty.competition.views.components"
      class="Bubble.as" 
      externalInfoUrl=""
      priority="1">Flex specific - You must add child only inside the createChildren method</violation>
      
  </file>
  
</pmd>'

  class TestFlexPmd < Test::Unit::TestCase
    def test_load
      r = FlexPmd::Report.new(TEST_XML)
      puts r.to_html
    end
  end

end
