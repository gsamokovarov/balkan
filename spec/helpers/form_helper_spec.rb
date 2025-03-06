require "rails_helper"

RSpec.case ApplicationHelper, type: :helper do
  let! :test_resource_class do
    Class.new do
      include ActiveModel::Model

      attr_accessor :name, :email, :age, :size, :agree, :bio
    end.then { it.set_temporary_name "test_resource" }
  end

  let(:test_resource) { test_resource_class.new }

  test "marketing_form generates a form with correct structure" do
    form_html = helper.marketing_form model: test_resource, url: "/test" do |f|
      f.text_input :name
    end

    assert_include? form_html, '<form class="space-y-10" action="/test" accept-charset="UTF-8" method="post">'
    assert_include? form_html, '<label class="flex flex-col space-y-3 sm:max-w-sm">'
    assert_include? form_html, '<span class="text-xl">Name</span>'
    assert_include? form_html, 'name="test_resource[name]"'
  end

  test "marketing_form includes required attribute and asterisk" do
    form_html = helper.marketing_form model: test_resource, url: "/test" do |f|
      f.text_input :name, required: true
    end

    assert_include? form_html, '<span class="text-xl">Name *</span>'
    assert_include? form_html, 'required="required"'
  end

  test "marketing_form renders email input with correct type" do
    form_html = helper.marketing_form model: test_resource, url: "/test" do |f|
      f.email_input :email
    end

    assert_include? form_html, 'type="email"'
    assert_include? form_html, 'name="test_resource[email]"'
  end

  test "marketing_form renders number input with correct type" do
    form_html = helper.marketing_form model: test_resource, url: "/test" do |f|
      f.number_input :age
    end

    assert_include? form_html, 'type="number"'
    assert_include? form_html, 'name="test_resource[age]"'
  end

  test "marketing_form renders select with options" do
    form_html = helper.marketing_form model: test_resource, url: "/test" do |f|
      f.select_input :size, %w[S M L]
    end

    assert_include? form_html, "<select"
    assert_include? form_html, '<option value="S">S</option>'
    assert_include? form_html, '<option value="M">M</option>'
    assert_include? form_html, '<option value="L">L</option>'
  end

  test "marketing_form renders checkbox with proper classes" do
    form_html = helper.marketing_form model: test_resource, url: "/test" do |f|
      f.check_box_input :agree
    end

    assert_include? form_html, 'type="checkbox"'
    assert_include? form_html, 'class="w-5 h-5 text-banitsa-600 border-neutral-600 rounded-sm'
  end

  test "marketing_form renders submit button with custom text" do
    form_html = helper.marketing_form model: test_resource, url: "/test" do |f|
      f.submit "Custom Submit"
    end

    assert_include? form_html, '<button name="button" type="submit" class="btn-primary w-fit">Custom Submit</button>'
  end

  test "marketing_form renders captcha" do
    allow(helper).to receive(:h_captcha).and_return('<div class="h-captcha"></div>'.html_safe)

    form_html = helper.marketing_form model: test_resource, url: "/test", &:captcha

    assert_include? form_html, '<div class="h-captcha"></div>'
  end

  test "marketing_form works with scope instead of model" do
    form_html = helper.marketing_form scope: :test_resource, url: "/test" do |f|
      f.text_input :name
    end

    assert_include? form_html, 'name="test_resource[name]"'
  end
end
