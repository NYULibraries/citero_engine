#!/bin/env ruby
# encoding: utf-8
require 'test_helper'
require 'rack/utils'
require 'citero-jruby'


module CiteroEngine
  class CiteroEngineControllerTest < ActionController::TestCase
    setup :initialize_cite
    teardown :clear

    def initialize_cite
      @controller = CiteroEngineController.new
    end

    def clear
      @controller = nil
    end

    test "should convert format to format" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        Citero.from_formats.each do |from|
          Citero.to_formats.each do |to|
            get :index, :data => $formats[from.to_sym], :from_format => from, :to_format => to,  :use_route => :export_citations
            assert_response :success
            clear
            initialize_cite
          end
        end
      end
    end

    test "should raise an error when a field is missing in index" do
        $acts_as_citable_classes.each do |citable_class|
          CiteroEngine.acts_as_citable_class = citable_class
          get :index, :id => "error", :use_route => :export_citations
          assert_response :bad_request
          clear
          initialize_cite
        end
    end

    test "should test translate POST and GET" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        get :index, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :use_route => :export_citations
        assert_response :success
        clear
        initialize_cite
        post :index, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :use_route => :export_citations
        assert_response :success
        clear
        initialize_cite
      end
    end

    test "should convert openurl to format" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        Citero.to_formats.each do |to|
          get :index, "rft_val_fmt" => "info:ofi/fmt:kev:mtx:book", :to_format => to,  :use_route => :export_citations
          assert_response :success
          clear
          initialize_cite
        end
      end
    end

    test "should redirect with specified protocol" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        CiteroEngine.endnote.protocol = :https
        get :index, :to_format => "endnote", :use_route => :export_citations
        assert_redirected_to "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=https%3A%2F%2Ftest.host%2Fcitero_engine%2Fexport_citations%3Fresource_key%3D5b174a9f0bbae8e128c8fd3c5c74b22c5a772cfd%26to_format%3Dris"
        CiteroEngine.endnote.callback_protocol = :http
        clear
        initialize_cite
      end
    end

    test "should redirect to endnote" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        get :index, :to_format => "endnote", :use_route => :export_citations
        assert_redirected_to "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=http%3A%2F%2Ftest.host%2Fcitero_engine%2Fexport_citations%3Fresource_key%3D5b174a9f0bbae8e128c8fd3c5c74b22c5a772cfd%26to_format%3Dris"
        clear
        initialize_cite
      end
    end

    test "should redirect to refworks" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        Citero.from_formats.each do |from|
          get :index, :to_format => "refworks", :from_format => from, :data => $formats[from], :use_route => :export_citations
          assert_response :success
          assert_template :partial => '_external_form'
          clear
          initialize_cite
        end
      end
    end

    test "should redirect to easybib" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        Citero.from_formats.each do |from|
          get :index, :to_format => "easybibpush", :from_format => from, :data => $formats[from], :use_route => :export_citations
          assert_response :success
          assert_template :partial => '_external_form'
          clear
          initialize_cite
        end
      end
    end

    test "should batch map multiple citations" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        post :index, :to_format => "ris", :from_format => ["csf", "csf"], :data => ["itemType: book", "itemType: journalArticle"], :use_route => :export_citations
        assert_response :success
        clear
        initialize_cite
      end
    end

    test "should attempt to find by resource_key" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        get :index, :to_format => "ris", :resource_key => "unknown", :use_route => :export_citations
        assert_response :bad_request
        clear
        initialize_cite
      end
    end

    test "should attempt to find by id" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        get :index, :to_format => "ris", :id => "unknown", :use_route => :export_citations
        assert_response :bad_request
        clear
        initialize_cite
      end
    end

    test "should handle missing to_format" do
      $acts_as_citable_classes.each do |citable_class|
        CiteroEngine.acts_as_citable_class = citable_class
        get :index, :data => "itemType: book", :from_format => "csf", :use_route => :export_citations
        assert_response :bad_request
        clear
        initialize_cite
      end
    end

  end
end
