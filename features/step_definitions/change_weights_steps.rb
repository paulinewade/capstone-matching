When('I visit the change weights page') do
    visit '/changeweights'
end

Given('the following score attributes exist:') do |table|
    table.hashes.each do |score_attribute_params|
        feature = score_attribute_params['feature']
        feature_weight = score_attribute_params['feature_weight']
        attribute_id = score_attribute_params['attribute_id']
        ScoresAttribute.create!(attribute_id: attribute_id, feature: feature, feature_weight: feature_weight) 
    end
end

Then('I should see percentage input fields') do
    within('table') do
      expect(page).to have_css('input[type="text"][name^="feature_weights"]')
    end
  end
  
Then('I should see a {string} button') do |button_text|
    expect(page).to have_button(button_text)
end


  Then('I should see the following pre-filled feature weights') do |table|
    expected_weights = table.raw.map { |row| row[0].to_f} # Convert from percentage to decimal
    actual_weights = all('input[type="text"][name="feature_weights[]"]').map { |input| input.value.to_f / 100.0 } # Convert from percentage to decimal
    expect(actual_weights).to eq(expected_weights)
  end
  
  When('I fill in {string} for {string} at index {int}') do |value, feature_name, index|
    input_fields = all(:css, "input[name='feature_weights[]']")
    input_field = input_fields[index - 1]
    input_field.set(value)
  end
  
  Then("I should see {string} message") do |message|
    expect(page).to have_content(message)
  end
  