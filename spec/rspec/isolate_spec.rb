require_relative '../support/example_classes'

RSpec.describe Rspec::Isolate do
  it "has a version number" do
    expect(Rspec::Isolate::VERSION).not_to be nil
  end

  context "when calling an isolated class", error_on_call: [ ChildClass ] do
    it "errors" do
      expect do
        parent = ParentClass.new
        parent.parent_hello
      end.to raise_error(IsolationError, "Method :new called on isolated class ChildClass")
    end

    it "does not error when isolated" do
      fake_child = double :child, child_hello: "fake called"
      parent = ParentClass.new(fake_child)
      expect(parent.parent_hello).to eq "fake called"
    end
  end

  context "when calling a deeply nested isolated class", error_on_call: [ NestingModule::NestingModuleTwo::ChildClass ] do
    it "errors" do
      expect do
        parent = ParentClassWithNesting.new
        parent.parent_hello
      end.to raise_error(IsolationError, "Method :new called on isolated class NestingModule::NestingModuleTwo::ChildClass")
    end

    it "does not error when isolated" do
      fake_child = double :child, child_hello: "fake called"
      parent = ParentClassWithNesting.new(fake_child)
      expect(parent.parent_hello).to eq "fake called"
    end
  end

  context "when calling a warn isolated class", warn_on_call: [ ChildClass ] do
    it "calls and warns" do
      expect do
        parent = ParentClass.new
        expect(parent.parent_hello).to eq "hello"
      end.to output("Method :new called on isolated class ChildClass\n").to_stderr
    end

    it "does not warn or call when isolated" do
      expect do
        fake_child = double :child, child_hello: "fake called"
        parent = ParentClass.new(fake_child)
        expect(parent.parent_hello).to eq "fake called"
      end.not_to output("Method :new called on isolated class ChildClass\n").to_stderr
    end
  end

  context "when calling a deeply nested warn isolated class", warn_on_call: [ NestingModule::NestingModuleTwo::ChildClass ] do
    it "calls and warns" do
      expect do
        parent = ParentClassWithNesting.new
        expect(parent.parent_hello).to eq "hello"
      end.to output("Method :new called on isolated class NestingModule::NestingModuleTwo::ChildClass\n").to_stderr
    end

    it "does not warn or call when isolated" do
      expect do
        fake_child = double :child, child_hello: "fake called"
        parent = ParentClassWithNesting.new(fake_child)
        expect(parent.parent_hello).to eq "fake called"
      end.not_to output("Method :new called on isolated class NestingModule::NestingModuleTwo::ChildClass\n").to_stderr
    end
  end
end
