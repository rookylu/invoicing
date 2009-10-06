ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:monthdayyear => "%b %d, %Y")
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:monthdayyear => "%b %d, %Y")

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:standard => "%d/%m/%Y")
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:standard => "%d/%m/%Y")

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:yearonly => "%Y")
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:yearonly => "%Y")
