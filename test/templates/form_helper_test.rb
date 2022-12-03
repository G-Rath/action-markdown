require "test_helper"

class ActionMarkdown::FormHelperTest < ActionView::TestCase
  tests ActionMarkdown::TagHelper

  def form_with(*, **)
    @output_buffer = super
  end

  teardown do
    I18n.backend.reload!
  end

  setup do
    I18n.backend.store_translations("placeholder",
      activerecord: {
        attributes: {
          article: {
            content: "Article content"
          }
        }
      }
    )
  end

  test "#markdown_field_tag" do
    article = Article.new

    form_with model: article do |f|
      markdown_field_tag :content, article.content
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea>' \
          ' ' \
        '</textarea>' \
      '</form>',
      output_buffer.squish
  end

  test "form with a markdown_field" do
    form_with model: Article.new do |f|
      f.markdown_field :content
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea name="article[content]" id="article_content">' \
          ' ' \
        '</textarea>' \
      '</form>',
    output_buffer.squish
  end

  test "form with a markdown_field and a custom class" do
    form_with model: Article.new do |f|
      f.markdown_field :content, class: "custom-class"
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea name="article[content]" id="article_content" class="custom-class">' \
          ' ' \
        '</textarea>' \
      '</form>',
    output_buffer.squish
  end

  test "form with markdown_field for non-attribute" do
    form_with model: Article.new do |f|
      f.markdown_field :not_an_attribute
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea name="article[not_an_attribute]" id="article_not_an_attribute">' \
          ' ' \
        '</textarea>' \
      '</form>',
    output_buffer.squish
  end

  test "modelless form with markdown_field" do
    form_with url: "/articles" do |f|
      f.markdown_field :content
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea name="content" id="content">' \
          ' ' \
        '</textarea>' \
      '</form>',
      output_buffer.squish
  end

  test "form with markdown_field having placeholder without locale" do
    form_with model: Article.new do |f|
      f.markdown_field :content, placeholder: true
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea placeholder="Content" name="article[content]" id="article_content">' \
          ' ' \
        '</textarea>' \
      '</form>',
    output_buffer.squish
  end

  test "form with markdown_field having placeholder with locale" do
    I18n.with_locale :placeholder do
      form_with model: Article.new do |f|
        f.markdown_field :content, placeholder: true
      end
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea placeholder="Article content" name="article[content]" id="article_content">' \
          ' ' \
        '</textarea>' \
      '</form>',
    output_buffer.squish
  end

  test "form with markdown_field with value" do
    form_with model: Article.new do |f|
      f.markdown_field :content, value: "# Title"
    end

    assert_dom_equal \
      '<form action="/articles" accept-charset="UTF-8" method="post">' \
        '<textarea name="article[content]" id="article_content">' \
          ' # Title' \
        '</textarea>' \
      '</form>',
    output_buffer.squish
  end
end