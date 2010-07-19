require 'spec_helper'

describe RdfModel::Vocabularies do
  def test_class
    Class.new do
      include RdfModel::Vocabularies
    end
  end

  it "should allow the addition of known vocabularies" do
    c = test_class
    v = "http://test.host/vocab/"
    c.vocabulary :test => v
    c.vocabulary[:test].should be_a_kind_of(RdfModel::Vocabularies::Vocabulary)
    c.vocab_test.uri.should == v
    c.respond_to?(:vocab_test).should be_true
  end

  it "should generate vocabulary item URIs on-demand" do
    c = test_class
    c.vocabulary :test => "http://test.host/vocab/"
    c.vocab_test.testing.should == "http://test.host/vocab/testing"
  end

  it "should not share vocabularies between classes" do
    c1 = test_class
    c2 = test_class
    c1.vocabulary :test => "http://test.host/vocab"
    c2.vocabulary[:test].should be_nil
  end

  it "should allow the inheritance of vocabularies to subclasses" do
    c1 = test_class
    c2 = Class.new(c1)
    c1.vocabulary :test => "http://test.host/vocab"
    c2.vocabulary[:test].should be_a_kind_of(RdfModel::Vocabularies::Vocabulary)
  end
end