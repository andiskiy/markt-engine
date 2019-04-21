shared_examples 'versionable' do |fields|
  fields.each do |field|
    it "new #{field}" do
      time = 10.seconds.from_now
      expect(model.send("old_#{field}", time)).to eq(send("new_#{field}"))
    end

    it "old #{field}" do
      time = 10.seconds.ago
      expect(model.send("old_#{field}", time)).to eq(send("old_#{field}"))
    end
  end
end
