# Rspec::Also

RSpec::Also is a crazy hack so you can write tests in tree form:

``` ruby
it "posts" do
  click_link "Posts"

  also "looking at a post" do
    click_link "My first post"

    also "deleting it removes it from the list" do
      click_button "Delete"
      page.should_not have_content "My first post"
    end

    also "editing changes the title" do
      click_link "Edit"
      fill_in "Title", with: "My awesome post"
      click_button "Save"
      page.should have_content "My awesome post"
    end
  end

  also "deleting it directly removes it from the list" do
    find("li", text: "My first post").click_button "Delete"
    page.should_not have_content "My first post"
  end
end
```

The above code will run through all scenarios. This means you can write your
tests in a nicely branching structure, always resuming from where you
previously were. Only what actually happens is that the above example is run
three times in succession, each time choosing a different branch.

## Limitations



## Installation

Add this line to your application's Gemfile:

    gem 'rspec-also'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-also

## Usage

It doesn't work yet, don't use it!

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rspec-also/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
