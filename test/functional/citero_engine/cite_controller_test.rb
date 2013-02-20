#!/bin/env ruby
# encoding: utf-8
require 'test_helper'
require 'rack/utils'
require 'citero'


module CiteroEngine
  class CiteControllerTest < ActionController::TestCase
    fixtures :"citero_engine/records"
    setup :initialize_cite
    teardown :clear
    
    def initialize_cite
      @controller = CiteController.new
    end
    
    def clear
      @controller = nil
    end
    
    test "should convert format to format" do
      Citero.map("").from_formats.each do |from| 
        Citero.map("").to_formats.each do |to|
          get :flow, :id => Record.find_by_title(from)[:id], :to_format => to,  :use_route => :cite
          assert_response :success
          clear
          initialize_cite
        end
      end
    end
    
    test "should raise an error when a field is missing in index" do
       get :flow, :id => "error", :use_route => :cite
       assert_response :bad_request
    end
    
    test "should test translate POST and GET" do
      get :flow, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :use_route => :cite 
      assert_response :success
      clear
      initialize_cite
      post :flow, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :use_route => :cite 
      assert_response :success
    end
    
    test "should ignore invalid id" do
      get :flow, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :id => "unkown", :use_route => :cite 
      assert_response :success
    end
    
    test "should convert openurl to format" do
      Citero.map("").to_formats.each do |to|
        get :flow, "rft_val_fmt" => "info:ofi/fmt:kev:mtx:book", :to_format => to,  :use_route => :cite
        assert_response :success
      end
    end
    
    test "should redirect to endnote" do
      get :flow, :to_format => "endnote", :use_route => :cite
      assert_redirected_to "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=http%3A%2F%2Ftest.host%2Fassets%3Fresource_key%5B%5D%3Da3c7de8b5bea55c79fa672007be3e3d89fe5ee91_openurl%26to_format%3Dris"
    end
    
    test "should redirect to refworks" do
      get :flow, :to_format => "refworks", :use_route => :cite
      assert_redirected_to "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url=http%3A%2F%2Ftest.host%2Fassets%3Fresource_key%5B%5D%3D68b76a07f1e1e6ff4668ad8a1345fbff00ef87bf_openurl%26to_format%3Dris"
    end
    
    test "should redirect to easybib" do
      Citero.map("").from_formats.each do |from| 
        get :flow, :to_format => "easybibpush", :id => Record.find_by_title(from)[:id], :use_route => :cite
        assert_response :success
        assert_template :partial => '_external_form'
        clear
        initialize_cite
      end
    end 
    
    
    test "should batch map multiple citations" do
      post :flow, :to_format => "ris", :from_format => ["csf", "csf"], :data => ["itemType: book", "itemType: journalArticle"], :use_route => :cite
      assert_response :success
    end
  end
end