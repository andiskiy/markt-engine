def id_list(list)
  list.map(&:id).compact.uniq.sort
end

RSpec::Matchers.define :eq_id_list_of do |expected|
  match do |actual|
    (actual.first.is_a?(Numeric) ? actual : id_list(actual)) == id_list(expected)
  end

  failure_message_when_negated do |actual|
    "expected #{actual} to have an equal id list of #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} to not have an equal id list of #{expected}"
  end

  description do
    "have this ID list #{id_list(expected)}, but got #{id_list(actual)}"
  end
end
