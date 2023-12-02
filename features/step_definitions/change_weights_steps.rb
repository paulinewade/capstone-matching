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
    expected_weights = table.raw.flatten.map(&:to_f)

    # Get the page content as a string
    page_content = page.body
  
    # Check if each expected weight appears in the page content
    expected_weights.each do |expected_weight|
      expect(page_content).to include(expected_weight.to_s)
    end
  end
  
  When('I fill in {string} for {string} at index {int}') do |value, feature_name, index|
    if index == 0
      input_field = first(:css, "input")

      input_field.set(value)
    else
      input_fields = all(:css, "input").to_a
      input_field = input_fields[index]
      input_field.set(value) if input_field
    end

  end
  
  Then("I should see {string} message") do |message|
    expect(page).to have_content(message)
  end
  