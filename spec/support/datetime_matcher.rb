RSpec::Matchers.define :be_datetime_format do |expected|
  match do |actual|
    expect(expected.in_time_zone(Time.zone.name).strftime(MarktEngine::DATETIME_FORMAT)).to eq(actual)
  end
end
