#!/bin/env ruby
# encoding: utf-8
require 'test_helper'
require 'rack/utils'

module Citation
  class CiteControllerTest < ActionController::TestCase
    fixtures :"citation/records"
    
    test "should create a record" do
      assert_difference('Record.count') do
        post :create, "data" => "itemType: book", "from" => "csf", "ttl" => "dummy", :use_route => :cite
      end
      assert_redirected_to '/cite'
    end
    
    test "should convert format to format" do
      formats = [:csf,:ris,:pnx,:bibtex,:openurl]
      formats.each do |from| 
        formats.each do |to|
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
      get :translate, "data" => "itemType: book", "from" => "csf", "to" => "pnx", :use_route => :cite 
      assert_response :success
      post :translate, "data" => "itemType: book", "from" => "csf", "to" => "pnx", :use_route => :cite 
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
    
    test "should redirect to endnote" do
      get :redir, "format" => "endnote", :use_route => :cite
      assert_redirected_to "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=http%3A%2F%2Ftest.host/assets?action=redir&format=ris"
    end
    
    test "should redirect to refworks" do
      get :redir, "format" => "refworks", :use_route => :cite
      assert_redirected_to "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url=http%3A%2F%2Ftest.host/assets?action=redir&format=ris"
    end
  end
end