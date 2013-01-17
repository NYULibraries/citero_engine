#!/bin/env ruby
# encoding: utf-8
require 'test_helper'
require 'rack/utils'
require 'citero'


module CiteroEngine
  class CiteControllerTest < ActionController::TestCase
    fixtures :"citero_engine/records"
    
    test "should create a record" do
      assert_difference('Record.count') do
        post :create, "data" => "itemType: book", "from" => "csf", "ttl" => "dummy", :use_route => :cite
      end
      assert_redirected_to '/cite'
    end
    
    test "should convert format to format" do
      Citero.map("").from_formats.each do |from| 
        Citero.map("").to_formats.each do |to|
          get :redir, "id" => from, "format" => to,  :use_route => :cite
          assert_response :success
        end
      end
    end
    
    test "should raise an error when a field is missing in creating" do
      assert_raise(ArgumentError) {post :create, "data" => "itemType: book", "from" => "csf", :use_route => :cite}
      assert_raise(ArgumentError) {post :create, "data" => "itemType: book", "ttl" => "dummy",  :use_route => :cite}
      assert_raise(ArgumentError) {post :create, "data" => "itemType: book",  :use_route => :cite}
      assert_raise(ArgumentError) {post :create, "from" => "csf", "ttl" => "dummy",  :use_route => :cite}
      assert_raise(ArgumentError) {post :create, "from" => "csf",  :use_route => :cite}
      assert_raise(ArgumentError) {post :create, "ttl" => "dummy",  :use_route => :cite}
    end
    
    test "should raise an error when a field is missing in index" do
       assert_raise(ArgumentError) { get :redir, "id" => "error", :use_route => :cite }
    end
    
    test "should test translate POST and GET" do
      get :translate, "data" => "itemType: book", "from" => "csf", "to" => "ris", :use_route => :cite 
      assert_response :success
      post :translate, "data" => "itemType: book", "from" => "csf", "to" => "ris", :use_route => :cite 
      assert_response :success
    end
    
    test "should raise an error when a field is missing in translate" do
      assert_raise(ArgumentError) { get :translate, "data" => "itemType: book", "from" => "csf", :use_route => :cite }
      assert_raise(ArgumentError) { get :translate, "data" => "itemType: book", "to" => "csf", :use_route => :cite }
      assert_raise(ArgumentError) { get :translate, "from" => "csf", "to" => "csf", :use_route => :cite }
      
      assert_raise(ArgumentError) { post :translate, "data" => "itemType: book", "from" => "csf", :use_route => :cite }
      assert_raise(ArgumentError) { post :translate, "data" => "itemType: book", "to" => "csf", :use_route => :cite }
      assert_raise(ArgumentError) { post :translate, "from" => "csf", "to" => "csf", :use_route => :cite }
    end
    
    test "should convert openurl to format" do
      Citero.map("").to_formats.each do |to|
        get :redir, "rft_val_fmt" => "info:ofi/fmt:kev:mtx:book", "format" => to,  :use_route => :cite
        assert_response :success
      end
    end
    
    test "should redirect to endnote" do
      get :redir, "format" => "endnote", :use_route => :cite
      assert_redirected_to "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=http%3A%2F%2Ftest.host%2Fassets%3Faction%3Dredir%26format%3Dris"
    end
    
    test "should redirect to refworks" do
      get :redir, "format" => "refworks", :use_route => :cite
      assert_redirected_to "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url=http%3A%2F%2Ftest.host%2Fassets%3Faction%3Dredir%26format%3Dris"
    end
    
    test "should redirect to easybib" do
      Citero.map("").from_formats.each do |from| 
        get :redir, "format" => "pusheasybib", "id" => from, :use_route => :cite
        assert_response :success
      end
    end
    
    test "should mount the engine" do
      get :index, :use_route => :cite
      assert_response :success
    end
  end
end