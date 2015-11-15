# Defines the matching rules for Guard.
guard :minitest, spring: true, all_on_start: false do
  # Watch all test files.
  watch %r{^test/(.*)/?(.*)_test\.rb$}

  # Run tests if the helper or the routes is changed.
  watch('test/test_helper.rb') { 'test' }
  watch('config/routes.rb')    { integration_tests }

  # Watch models.
  watch %r{^app/models/(.*?)\.rb$} do |matches|
    "test/models/#{matches[1]}_test.rb"
  end

  # Watch controllers.
  watch %r{^app/controllers/(.*?)_controller\.rb$} do |matches|
    resource_tests(matches[1])
  end

  # Watch views.
  watch %r{^app/views/([^/]*?)/.*\.html\.erb$} do |matches|
    ["test/controllers/#{matches[1]}_controller_test.rb"] +
    integration_tests(matches[1])
  end

  # Watch helpers.
  watch %r{^app/helpers/(.*?)_helper\.rb$} do |matches|
    integration_tests(matches[1])
  end

  # Watch the layout template.
  watch 'app/views/layouts/application.html.erb' do
    'test/integration/site_layout_test.rb'
  end

  watch 'app/helpers/sessions_helper.rb' do
    integration_tests << 'test/helpers/sessions_helper_test.rb'
  end

  watch 'app/controllers/sessions_controller.rb' do
    ['test/controllers/sessions_controller_test.rb',
     'test/integration/users_login_test.rb']
  end

  watch 'app/controllers/account_activations_controller.rb' do
    'test/integration/users_signup_test.rb'
  end

  watch %r{app/views/users/*} do
    resource_tests('users') +
    ['test/integration/microposts_interface_test.rb']
  end
end

# Returns the integration tests corresponding to the given resource.
def integration_tests(resource = :all)
  if resource == :all
    Dir["test/integration/*"]
  else
    Dir["test/integration/#{resource}_*.rb"]
  end
end

# Returns the controller tests corresponding to the given resource.
def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

# Returns all tests for the given resource.
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end
