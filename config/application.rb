require_relative 'boot'

require 'rails/all'

require 'dotenv/load'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CapstoneMatching
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.student_status_constants = {
      'gender'=>['Male', 'Female', 'Non-Binary', 'Other'],
       'work_auth'=> ['US Citizen', 'Permanent Resident', 'Work Visa', 'Student Visa', 'Not Authorized to Work'],
       'contract_sign'=> ['Not Willing at All', 'NDA Only', 'IP Only', 'Ok with Any Agreements'],
      'nationality'=> ['Afghan', 'Albanian', 'Algerian', 'American', 'Andorran', 'Angolan', 'Anguillan', 'Citizen of Antigua and Barbuda',
      'Argentine', 'Armenian', 'Australian', 'Austrian', 'Azerbaijani',
      'Bahamian', 'Bahraini', 'Bangladeshi', 'Barbadian', 'Belarusian', 'Belgian', 'Belizean', 'Beninese',
      'Bermudian', 'Bhutanese', 'Bolivian', 'Citizen of Bosnia and Herzegovina',
      'Botswanan', 'Brazilian', 'British', 'British Virgin Islander',
      'Bruneian', 'Bulgarian', 'Burkinan', 'Burmese', 'Burundian',
      'Cambodian', 'Cameroonian', 'Canadian', 'Cape Verdean',
      'Cayman Islander', 'Central African', 'Chadian', 'Chilean',
      'Chinese', 'Colombian', 'Comoran', 'Congolese (Congo)',
      'Congolese (DRC)', 'Cook Islander', 'Costa Rican', 'Croatian',
      'Cuban', 'Cymraes', 'Cymro', 'Cypriot', 'Czech',
      'Danish', 'Djiboutian', 'Dominican', 'Citizen of the Dominican Republic',
      'Dutch',
      'East Timorese', 'Ecuadorean', 'Egyptian', 'Emirati',
      'English', 'Equatorial Guinean', 'Eritrean', 'Estonian',
      'Ethiopian',
      'Faroese', 'Fijian', 'Filipino', 'Finnish',
      'French',
      'Gabonese', 'Gambian', 'Georgian', 'German',
      'Ghanaian', 'Gibraltarian', 'Greek', 'Greenlandic',
      'Grenadian', 'Guamanian', 'Guatemalan', 'Citizen of Guinea-Bissau',
      'Guinean', 'Guyanese',
      'Haitian', 'Honduran', 'Hong Konger', 'Hungarian',
      'Icelandic', 'Indian', 'Indonesian', 'Iranian',
      'Iraqi', 'Irish', 'Israeli', 'Italian',
      'Ivorian',
      'Jamaican', 'Japanese', 'Jordanian',
      'Kazakh', 'Kenyan', 'Kittitian', 'Citizen of Kiribati',
      'Kosovan', 'Kuwaiti', 'Kyrgyz',
      'Lao', 'Latvian', 'Lebanese', 'Liberian',
      'Libyan', 'Liechtenstein citizen', 'Lithuanian', 'Luxembourger',
      'Macanese', 'Macedonian', 'Malagasy', 'Malawian',
      'Malaysian', 'Maldivian', 'Malian', 'Maltese',
      'Marshallese', 'Martiniquais', 'Mauritanian', 'Mauritian',
      'Mexican', 'Micronesian', 'Moldovan', 'Monegasque',
      'Mongolian', 'Montenegrin', 'Montserratian', 'Moroccan',
      'Mosotho', 'Mozambican',
      'Namibian', 'Nauruan', 'Nepalese', 'New Zealander',
      'Nicaraguan', 'Nigerian', 'Nigerien', 'Niuean',
      'North Korean', 'Northern Irish', 'Norwegian',
      'Omani',
      'Pakistani', 'Palauan', 'Palestinian', 'Panamanian',
      'Papua New Guinean', 'Paraguayan', 'Peruvian', 'Pitcairn Islander',
      'Polish', 'Portuguese', 'Prydeinig', 'Puerto Rican',
      'Qatari',
      'Romanian', 'Russian', 'Rwandan',
      'Salvadorean', 'Sammarinese', 'Samoan', 'Sao Tomean',
      'Saudi Arabian', 'Scottish', 'Senegalese', 'Serbian',
      'Citizen of Seychelles', 'Sierra Leonean', 'Singaporean', 'Slovak',
      'Slovenian', 'Solomon Islander', 'Somali', 'South African',
      'South Korean', 'South Sudanese', 'Spanish', 'Sri Lankan',
      'St Helenian', 'St Lucian', 'Stateless', 'Sudanese',
      'Surinamese', 'Swazi', 'Swedish', 'Swiss',
      'Syrian',
      'Taiwanese', 'Tajik', 'Tanzanian', 'Thai',
      'Togolese', 'Tongan', 'Trinidadian', 'Tristanian',
      'Tunisian', 'Turkish', 'Turkmen', 'Turks and Caicos Islander',
      'Tuvaluan',
      'Ugandan', 'Ukrainian', 'Uruguayan', 'Uzbek',
      'Vatican citizen', 'Citizen of Vanuatu', 'Venezuelan', 'Vietnamese',
      'Vincentian',
      'Wallisian', 'Welsh',
      'Yemeni',
      'Zambian', 'Zimbabwean']
    }
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Central Time (US & Canada)'
    # config.eager_load_paths << Rails.root.join('extras')
  end
end
