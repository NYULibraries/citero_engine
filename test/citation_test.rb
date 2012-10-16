#!/bin/env ruby
# encoding: utf-8
require 'test_helper'

$CSF = "itemType: book\nauthor: Alexander Dumas\ncontributor: D'Artagnan\ntitle: The Three Musketeers"
$RIS = "TY  -  JOUR\nAU  -  Shannon,Claude E.\nER  -\n\n"
$PNX = "<display>" + "<type>book</type>" + "<title>"+ "Information literacy : infiltrating the agenda, challenging minds"+ "</title>"+ "<contributor>Geoff Walton (Geoff L.); Alison Pope</contributor>"+ "<publisher>Oxford : Chandos Publishing</publisher>"+ "<creationdate>2011</creationdate>"+ "<format>xxvi, 294 p. ; 24 cm.</format>"+ "<identifier>$$Cisbn$$V1843346109; $$Cisbn$$V9781843346104</identifier>"+ "<subject>"+ "Information literacy; Information literacy -- Study and teaching; Information literacy -- Web-based instruction; Library orientation for graduate students; Information services -- User education"+ "</subject>"+ "<description>"+ "$$Ccontents$$VIntroduction / Alison Pope and Geoff Walton -- Information literate pedagogy : developing a levels framework for the Open University / Katharine Reedy and Kirsty Baker -- Information literacy in the workplace and the employablity agenda / John Crawford and Christine Irving -- Information literacy in the context of contemporary teaching methods in higher education / Chris Wakeman -- 'Enquiring Minds' and the role of information literacy in the design, management and assessment of student research tasks / Keith Puttick -- Are we sharing our toys in the sandpit? Issues surrounding the design, creation, reuse and re-purposing of learning objects to support information skills and teaching? / Nancy Graham -- Spielburg your way to information literacy : producing educational movies and videos / Gareth Johnson -- Information literacy and noö̈politics / Andrew Whitworth -- Contemporary technologies' influence on learning as a social practice / Ben Scoble -- Understanding the information literacy competencies of UK Higher Education students / Jillian R. Griffiths and Bob Glass."+ "</description>"+ "<language>eng</language>"+ "<relation>"+ "$$Cseries $$VChandos information professional series"+ "</relation>"+ "<source>nyu_aleph</source>"+ "<availlibrary>"+ "$$INYU$$LBOBST$$1Main Collection$$2(ZA3075 .I54 2011 )$$Savailable$$31$$40$$5N$$60$$XNYU50$$YBOBST$$ZMAIN"+ "</availlibrary>"+ "<lds02>nyu_aleph003522839</lds02>"+ "<lds01>NYU</lds01>"+ "<availinstitution>$$INYU$$Savailable</availinstitution>"+ "<availpnx>available</availpnx>"+ "</display>"
$BIBTEX = "@article{Adams2001,\nauthor = {Adams, Nancy K and DeSilva, Shanaka L and Self, Steven and Salas, Guido and Schubring, Steven and Permenter, Jason L and Arbesman, Kendra},\nfile = {:Users/heatherwright/Documents/Scientific Papers/Adams\\_Huaynaputina.pdf:pdf;::},\njournal = {Bulletin of Volcanology},\nkeywords = {Vulcanian eruptions,breadcrust,plinian},\npages = {493--518},\ntitle = {{The physical volcanology of the 1600 eruption of Huaynaputina, southern Peru}},\nvolume = {62},\nyear = {2001}\n}"
$OPENURL = "https://getit.library.nyu.edu/resolve?url_ver=Z39.88-2004&rft_val_fmt=info:ofi/fmt:kev:mtx:book&rft.isbn=0836218310&rft.btitle=The+Far+Side+Gallery+3&rft.au=Gary+Larson"

$CSF_REGEX = /(^[.a-zA-Z0-9]+(\s*:\s*)[^\n]+$)+/
$RIS_REGEX = /(^[\w\d]{1,6}  - [\w\W]*$|\s)+/
$PNX_REGEX = /<[\w\W]*><[\w\s"]+>[\w\W]*<\/[\w\s]+>/
$BIBTEX_REGEX = /@[^{]+{(?:[^{}]|{[^{}]*}|{{[^{}]*}})*}/
$OPENURL_REGEX = /[:\/%$\-_\.\+!\*'\(\),a-zA-Z0-9]*\?[&?[:\/%$\-_\.\+!\*'\(\),a-zA-Z0-9]+=[:\/%$\-_\.\+!\*'\(\),a-zA-Z0-9]+]+/

$Cit = Citation::Tool.new

class CitationTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Citation
  end
end

class CSFTest < ActiveSupport::TestCase
  def test_test_CSFinCSFOut
    assert_match( $CSF_REGEX, $Cit.map($CSF).from("csf").to("csf") )
  end

  def test_test_RISinCSFOut
    assert_match( $CSF_REGEX, $Cit.map($RIS).from("ris").to("csf") )
  end

  def test_PNXinCSFOut
    assert_match( $CSF_REGEX, $Cit.map($PNX).from("pnx").to("csf") )
  end

  def test_BIBTEXinCSFOut
    assert_match( $CSF_REGEX, $Cit.map($BIBTEX).from("bibtex").to("csf") )
  end

  def test_OPENURLinCSFOut
    assert_match( $CSF_REGEX, $Cit.map($OPENURL).from("openurl").to("csf") )
  end
end

class RISTest < ActiveSupport::TestCase
  def test_CSFinRISOut
    assert_match( $RIS_REGEX, $Cit.map($CSF).from("csf").to("ris") )
  end

  def test_RISinRISOut
    assert_match( $RIS_REGEX, $Cit.map($RIS).from("ris").to("ris") )
  end

  def test_PNXinRISOut
    assert_match( $RIS_REGEX, $Cit.map($PNX).from("pnx").to("ris") )
  end

  def test_BIBTEXinRISOut
    assert_match( $RIS_REGEX, $Cit.map($BIBTEX).from("bibtex").to("ris") )
  end

  def test_OPENURLinRISOut
    assert_match( $RIS_REGEX, $Cit.map($OPENURL).from("openurl").to("ris") )
  end
end

class PNXTest < ActiveSupport::TestCase
  def test_CSFinPNXOut
    assert_match( $PNX_REGEX, $Cit.map($CSF).from("csf").to("pnx") )
  end

  def test_RISinPNXOut
    assert_match( $PNX_REGEX, $Cit.map($RIS).from("ris").to("pnx") )
  end

  def test_PNXinPNXOut
    assert_match( $PNX_REGEX, $Cit.map($PNX).from("pnx").to("pnx") )
  end

  def test_BIBTEXinPNXOut
    assert_match( $PNX_REGEX, $Cit.map($BIBTEX).from("bibtex").to("pnx") )
  end

  def test_OPENURLinPNXOut
    assert_match( $PNX_REGEX, $Cit.map($OPENURL).from("openurl").to("pnx") )
  end
end

class BIBTEXTest < ActiveSupport::TestCase
  def test_CSFinBIBTEXOut
    assert_match( $BIBTEX_REGEX, $Cit.map($CSF).from("csf").to("bibtex") )
  end

  def test_RISinBIBTEXOut
    assert_match( $BIBTEX_REGEX, $Cit.map($RIS).from("ris").to("bibtex") )
  end

  def test_PNXinBIBTEXOut
    assert_match( $BIBTEX_REGEX, $Cit.map($PNX).from("pnx").to("bibtex") )
  end

  def test_BIBTEXinBIBTEXOut
    assert_match( $BIBTEX_REGEX, $Cit.map($BIBTEX).from("bibtex").to("bibtex") )
  end

  def test_OPENURLinBIBTEXOut
    assert_match( $BIBTEX_REGEX, $Cit.map($OPENURL).from("openurl").to("bibtex") )
  end
end

class OPENURLTest < ActiveSupport::TestCase
  def test_CSFinOPENURLOut
    assert_match( $OPENURL_REGEX, $Cit.map($CSF).from("csf").to("openurl") )
  end

  def test_RISinOPENURLOut
    assert_match( $OPENURL_REGEX, $Cit.map($RIS).from("ris").to("openurl") )
  end

  def test_PNXinOPENURLOut
    assert_match( $OPENURL_REGEX, $Cit.map($PNX).from("pnx").to("openurl") )
  end

  def test_BIBTEXinOPENURLOut
    assert_match( $OPENURL_REGEX, $Cit.map($BIBTEX).from("bibtex").to("openurl") )
  end

  def test_OPENURLinOPENURLOut
    assert_match( $OPENURL_REGEX, $Cit.map($OPENURL).from("openurl").to("openurl") )
  end
end

class CitationTest < ActiveSupport::TestCase
  def test_testUnrecognizedFromFormat
    assert_raise( ArgumentError ) { $Cit.map().from("unknown") }
  end

  def test_testUnrecognizedToFormat
    assert_raise( ArgumentError ) { $Cit.map().from("openurl").to("unkown") }
  end

  def test_testUnmatchedData
    assert_raise( TypeError ) { $Cit.map("").from("openurl").to("openurl") }
  end

  def test_missingFromFormat
    assert_raise( ArgumentError ) { $Cit.map().to("openurl") }
  end

  def test_missingToFormat
    assert_raise( ArgumentError ) { $Cit.map().from("openurl").to("") }
  end
end


