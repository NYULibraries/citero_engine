#!/bin/env ruby
# encoding: utf-8
require 'test_helper'
require 'rack/utils'
require 'citero'


module CiteroEngine
  class CiteControllerTest < ActionController::TestCase
    setup :initialize_cite
    teardown :clear
    
    def initialize_cite
      @controller = CiteController.new
    end
    
    def clear
      @controller = nil
    end
    
    test "should convert format to format" do
      Citero.from_formats.each do |from| 
        Citero.to_formats.each do |to|
          get :index, :data => $formats[from.to_sym], :from_format => from, :to_format => to,  :use_route => :cite
          assert_response :success
          clear
          initialize_cite
        end
      end
    end
    
    test "should raise an error when a field is missing in index" do
       get :index, :id => "error", :use_route => :cite
       assert_response :bad_request
    end
    
    test "should test translate POST and GET" do
      get :index, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :use_route => :cite 
      assert_response :success
      clear
      initialize_cite
      post :index, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :use_route => :cite 
      assert_response :success
    end
    
    test "should ignore invalid id" do
      get :index, :data => "itemType: book", :from_format => "csf", :to_format => "ris", :id => "unkown", :use_route => :cite 
      assert_response :success
    end
    
    test "should convert openurl to format" do
      Citero.to_formats.each do |to|
        get :index, "rft_val_fmt" => "info:ofi/fmt:kev:mtx:book", :to_format => to,  :use_route => :cite
        assert_response :success
      end
    end
    
    test "should redirect to endnote" do
      get :index, :to_format => "endnote", :use_route => :cite
      assert_redirected_to "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=http%3A%2F%2Ftest.host%2Fassets%3Fresource_key%5B%5D%3Dcc141d92caee81bd0601a5ee365fdf9ec31d23bb%26to_format%3Dris"
    end
    
    test "should redirect to refworks" do
      get :index, :to_format => "refworks", :use_route => :cite
      assert_redirected_to "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url=http%3A%2F%2Ftest.host%2Fassets%3Fresource_key%5B%5D%3D1ad5e264e5a423b07ab635982e79e35290b85c41%26to_format%3Dris"
    end
    
    test "should redirect to easybib" do
      Citero.from_formats.each do |from| 
        get :index, :to_format => "easybibpush", :from_format => from, :data => $formats[from], :use_route => :cite
        assert_response :success
        assert_template :partial => '_external_form'
        clear
        initialize_cite
      end
    end 
    
    test "should batch map multiple citations" do
      post :index, :to_format => "ris", :from_format => ["csf", "csf"], :data => ["itemType: book", "itemType: journalArticle"], :use_route => :cite
      assert_response :success
    end
    
    test "should fail since resource key is invalid" do 
      get :index, :to_format => "ris", :resource_key => "unknown", :use_route => :cite
      assert_response :bad_request
    end
  end
end