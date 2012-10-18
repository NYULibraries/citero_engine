class CitationTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Citation
  end
end

class CSFTest < ActiveSupport::TestCase
  def test_test_CSFinCSFOut
    assert_match( $CSF_REGEX, Citation.map($CSF).from("csf").to("csf") )
  end

  def test_test_RISinCSFOut
    assert_match( $CSF_REGEX, Citation.map($RIS).from("ris").to("csf") )
  end

  def test_PNXinCSFOut
    assert_match( $CSF_REGEX, Citation.map($PNX).from("pnx").to("csf") )
  end

  def test_BIBTEXinCSFOut
    assert_match( $CSF_REGEX, Citation.map($BIBTEX).from("bibtex").to("csf") )
  end

  def test_OPENURLinCSFOut
    assert_match( $CSF_REGEX, Citation.map($OPENURL).from("openurl").to("csf") )
  end
end

class RISTest < ActiveSupport::TestCase
  def test_CSFinRISOut
    assert_match( $RIS_REGEX, Citation.map($CSF).from("csf").to("ris") )
  end

  def test_RISinRISOut
    assert_match( $RIS_REGEX, Citation.map($RIS).from("ris").to("ris") )
  end

  def test_PNXinRISOut
    assert_match( $RIS_REGEX, Citation.map($PNX).from("pnx").to("ris") )
  end

  def test_BIBTEXinRISOut
    assert_match( $RIS_REGEX, Citation.map($BIBTEX).from("bibtex").to("ris") )
  end

  def test_OPENURLinRISOut
    assert_match( $RIS_REGEX, Citation.map($OPENURL).from("openurl").to("ris") )
  end
end

class PNXTest < ActiveSupport::TestCase
  def test_CSFinPNXOut
    assert_match( $PNX_REGEX, Citation.map($CSF).from("csf").to("pnx") )
  end

  def test_RISinPNXOut
    assert_match( $PNX_REGEX, Citation.map($RIS).from("ris").to("pnx") )
  end

  def test_PNXinPNXOut
    assert_match( $PNX_REGEX, Citation.map($PNX).from("pnx").to("pnx") )
  end

  def test_BIBTEXinPNXOut
    assert_match( $PNX_REGEX, Citation.map($BIBTEX).from("bibtex").to("pnx") )
  end

  def test_OPENURLinPNXOut
    assert_match( $PNX_REGEX, Citation.map($OPENURL).from("openurl").to("pnx") )
  end
end

class BIBTEXTest < ActiveSupport::TestCase
  def test_CSFinBIBTEXOut
    assert_match( $BIBTEX_REGEX, Citation.map($CSF).from("csf").to("bibtex") )
  end

  def test_RISinBIBTEXOut
    assert_match( $BIBTEX_REGEX, Citation.map($RIS).from("ris").to("bibtex") )
  end

  def test_PNXinBIBTEXOut
    assert_match( $BIBTEX_REGEX, Citation.map($PNX).from("pnx").to("bibtex") )
  end

  def test_BIBTEXinBIBTEXOut
    assert_match( $BIBTEX_REGEX, Citation.map($BIBTEX).from("bibtex").to("bibtex") )
  end

  def test_OPENURLinBIBTEXOut
    assert_match( $BIBTEX_REGEX, Citation.map($OPENURL).from("openurl").to("bibtex") )
  end
end

class OPENURLTest < ActiveSupport::TestCase
  def test_CSFinOPENURLOut
    assert_match( $OPENURL_REGEX, Citation.map($CSF).from("csf").to("openurl") )
  end

  def test_RISinOPENURLOut
    assert_match( $OPENURL_REGEX, Citation.map($RIS).from("ris").to("openurl") )
  end

  def test_PNXinOPENURLOut
    assert_match( $OPENURL_REGEX, Citation.map($PNX).from("pnx").to("openurl") )
  end

  def test_BIBTEXinOPENURLOut
    assert_match( $OPENURL_REGEX, Citation.map($BIBTEX).from("bibtex").to("openurl") )
  end

  def test_OPENURLinOPENURLOut
    assert_match( $OPENURL_REGEX, Citation.map($OPENURL).from("openurl").to("openurl") )
  end
end

class CitationTest < ActiveSupport::TestCase
  def test_testUnrecognizedFromFormat
    assert_raise( ArgumentError ) { Citation.map().from("unknown") }
  end

  def test_testUnrecognizedToFormat
    assert_raise( ArgumentError ) { Citation.map().from("openurl").to("unkown") }
  end

  def test_testUnmatchedData
    assert_raise( TypeError ) { Citation.map("").from("openurl").to("openurl") }
  end

  def test_missingFromFormat
    assert_raise( ArgumentError ) { Citation.map().to("openurl") }
  end

  def test_missingToFormat
    assert_raise( ArgumentError ) { Citation.map().from("openurl").to("") }
  end
end