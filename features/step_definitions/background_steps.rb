Given /^I have a background step$/ do
  puts "this is the background step"
  assert true
end

And /^I have another bg step$/ do
  puts "The other bg step"
end

Then /^The scenario should not fail$/ do
  puts "this step is in the scenario"
  assert true
end