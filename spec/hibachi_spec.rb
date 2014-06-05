require 'hibachi'

describe Hibachi do
  it "includes config methods" do
    expect(Hibachi).to respond_to(:configure)
    expect(Hibachi).to respond_to(:config)
  end

  it "includes chef run methods" do
    expect(Hibachi).to respond_to(:run_chef)
  end
end
